import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/srs/sm2.dart' as sm2;
import '../widgets/what_you_learned_screen.dart';

class WordDefinitionCard {
  final Word word;
  final String? example;
  final SrsCard? srsCard;

  WordDefinitionCard({
    required this.word,
    this.example,
    this.srsCard,
  });
}

class DefineItYourselfScreen extends ConsumerStatefulWidget {
  final String targetCefr;

  const DefineItYourselfScreen({
    super.key,
    this.targetCefr = 'C1',
  });

  @override
  ConsumerState<DefineItYourselfScreen> createState() => _DefineItYourselfScreenState();
}

class _DefineItYourselfScreenState extends ConsumerState<DefineItYourselfScreen>
    with SingleTickerProviderStateMixin {
  List<WordDefinitionCard> _cards = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  final TextEditingController _definitionController = TextEditingController();
  bool _isFlipped = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  int _score = 0;
  int _xpEarned = 0;
  int _correctCount = 0;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
    _loadWords();
  }

  @override
  void dispose() {
    _definitionController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  Future<void> _loadWords() async {
    final db = ref.read(databaseProvider);

    // Query advanced words
    final wordList = await (db.select(db.words)
          ..where((w) => w.cefr.equals(widget.targetCefr) | w.cefr.equals('C2') | w.cefr.equals('B2'))
          ..limit(25))
        .get();

    final allCards = <WordDefinitionCard>[];
    for (final w in wordList) {
      if (w.definitionEn == null || w.definitionEn!.isEmpty) continue;

      // Find example
      final ex = await (db.select(db.examples)..where((e) => e.wordId.equals(w.id))..limit(1)).getSingleOrNull();

      // Find SRS card
      final sc = await (db.select(db.srsCards)
            ..where((s) => s.itemType.equals('word') & s.itemId.equals(w.id))
            ..limit(1))
          .getSingleOrNull();

      allCards.add(WordDefinitionCard(word: w, example: ex?.sentence, srsCard: sc));
    }

    if (!mounted) return;

    if (allCards.isNotEmpty) {
      setState(() {
        _cards = List.of(allCards)..shuffle();
        _isLoading = false;
      });
    } else {
      // Fallback query all
      final fallback = await (db.select(db.words)..limit(10)).get();
      final list = fallback
          .map((w) => WordDefinitionCard(
                word: w,
                example: 'He used the word in an academic essay.',
              ))
          .toList();
      setState(() {
        _cards = list;
        _isLoading = false;
      });
    }
  }

  void _flipToReveal() {
    if (_definitionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write your definition in your own words first!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isFlipped = true;
    });
    _flipController.forward();
    AudioService().speakOrPlay(_cards[_currentIndex].word.lemma);
  }

  Future<void> _rateCard(int quality) async {
    final currentCard = _cards[_currentIndex];
    final isMastered = quality >= 3;

    if (isMastered) {
      _score += quality * 40;
      _xpEarned += quality * 5;
      _correctCount++;
      AudioService().playSfx(SfxType.correct);
    } else {
      AudioService().playSfx(SfxType.wrong);
    }

    // Update SRS schedule in database
    if (currentCard.srsCard != null) {
      final srsDao = ref.read(srsDaoProvider);
      final model = sm2.SrsCard(
        ease: currentCard.srsCard!.ease,
        interval: currentCard.srsCard!.intervalDays,
        reps: currentCard.srsCard!.repetitions,
        lapses: currentCard.srsCard!.lapses,
        due: DateTime.fromMillisecondsSinceEpoch(currentCard.srsCard!.dueAt),
      );

      sm2.review(model, quality);

      await srsDao.updateCardAfterReview(
        cardId: currentCard.srsCard!.id,
        newEase: model.ease,
        newIntervalDays: model.interval,
        newReps: model.reps,
        newLapses: model.lapses,
        nextDueEpochMs: model.due.millisecondsSinceEpoch,
      );

      await srsDao.logReview(
        cardId: currentCard.srsCard!.id,
        game: 'define_it_yourself',
        correct: isMastered,
        responseMs: 5000,
        quality: quality,
      );
    }

    _learnedItems.add(
      LearnedItem(
        term: '${currentCard.word.lemma} (${currentCard.word.pos ?? "word"})',
        definition: currentCard.word.definitionEn ?? '',
        example: _definitionController.text.trim(),
        wasMistake: !isMastered,
      ),
    );

    if (_currentIndex < _cards.length - 1) {
      _flipController.reverse().then((_) {
        setState(() {
          _currentIndex++;
          _isFlipped = false;
          _definitionController.clear();
        });
      });
    } else {
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    final total = _cards.isEmpty ? 1 : _cards.length;
    final accuracy = _correctCount / total;
    final durationMs = DateTime.now().millisecondsSinceEpoch - _roundStartTime;

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'define_it_yourself',
            mode: drift.Value('active_recall_${widget.targetCefr.toLowerCase()}'),
            startedAt: _roundStartTime,
            durationMs: durationMs,
            accuracy: accuracy,
            score: _score,
            xpEarned: _xpEarned,
          ),
        );

    final today = DateTime.now();
    final todayKey =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await ref.read(statsDaoProvider).recordDailyActivity(
          dayKey: todayKey,
          minutes: (durationMs / 60000).ceil(),
          xp: _xpEarned,
          itemsReviewed: total,
          goalMet: true,
        );

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WhatYouLearnedScreen(
          gameTitle: '🧠 Define It Yourself (${widget.targetCefr})',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => DefineItYourselfScreen(targetCefr: widget.targetCefr)),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.darkBg,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    if (_cards.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.darkBg,
        appBar: null,
        body: Center(
          child: Text('No vocabulary cards found.', style: TextStyle(color: AppColors.darkTextSecondary)),
        ),
      );
    }

    final card = _cards[_currentIndex];
    final progress = (_currentIndex + 1) / _cards.length;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Define It Yourself',
              style: TextStyle(color: AppColors.darkText, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Word ${_currentIndex + 1}/${_cards.length} • Active Recall Gym',
              style: const TextStyle(color: AppColors.darkTextSecondary, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: AppColors.warning, size: 16),
                const SizedBox(width: 4),
                Text('$_score XP',
                    style: const TextStyle(color: AppColors.darkText, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.darkSurface,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
              minHeight: 4,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
                    final isUnder = _flipAnimation.value > 0.5;
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_flipAnimation.value * pi),
                      alignment: Alignment.center,
                      child: isUnder
                          ? Transform(
                              transform: Matrix4.identity()..rotateY(pi),
                              alignment: Alignment.center,
                              child: _buildBackCard(card),
                            )
                          : _buildFrontCard(card),
                    );
                  },
                ),
              ),
            ),

            // Bottom action bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.darkSurface,
                border: Border(top: BorderSide(color: AppColors.darkBorder)),
              ),
              child: _isFlipped ? _buildRatingButtons() : _buildRevealButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrontCard(WordDefinitionCard card) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  card.word.cefr ?? 'C1',
                  style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up, color: AppColors.darkTextSecondary),
                onPressed: () => AudioService().speakOrPlay(card.word.lemma),
                tooltip: 'Pronunciation',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            card.word.lemma,
            style: const TextStyle(
              color: AppColors.darkText,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          if (card.word.ipa != null) ...[
            const SizedBox(height: 4),
            Text(
              card.word.ipa!,
              style: const TextStyle(color: AppColors.darkTextSecondary, fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
          if (card.word.pos != null) ...[
            const SizedBox(height: 6),
            Text(
              card.word.pos!,
              style: const TextStyle(color: AppColors.warning, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
          const SizedBox(height: 20),

          if (card.example != null && card.example!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.darkBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.format_quote, color: AppColors.darkTextSecondary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      card.example!,
                      style: const TextStyle(
                        color: AppColors.darkTextSecondary,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          const Text(
            'Explain this word in your own words (in English):',
            style: TextStyle(
              color: AppColors.darkText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _definitionController,
            maxLines: 4,
            style: const TextStyle(color: AppColors.darkText, fontSize: 15),
            decoration: InputDecoration(
              hintText: 'What does it mean? What are its defining characteristics? When is it used?',
              hintStyle: const TextStyle(color: AppColors.darkTextSecondary, fontSize: 13),
              filled: true,
              fillColor: AppColors.darkBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.darkBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.accent, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard(WordDefinitionCard card) {
    final userDef = _definitionController.text.trim();
    final dictDef = card.word.definitionEn ?? 'Definition unavailable.';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.word.lemma,
                style: const TextStyle(
                  color: AppColors.warning,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up, color: AppColors.darkTextSecondary),
                onPressed: () => AudioService().speakOrPlay(card.word.lemma),
              ),
            ],
          ),
          const Divider(color: AppColors.darkBorder, height: 20),

          // User's Definition
          const Text(
            'Your English Explanation:',
            style: TextStyle(color: AppColors.darkTextSecondary, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.darkBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Text(
              userDef.isNotEmpty ? userDef : '(No text entered)',
              style: const TextStyle(color: AppColors.darkText, fontSize: 14, height: 1.4),
            ),
          ),
          const SizedBox(height: 16),

          // Official Dictionary Definition
          const Text(
            'Oxford / Cambridge Definition:',
            style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
            ),
            child: Text(
              dictDef,
              style: const TextStyle(
                color: AppColors.darkText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),

          if (card.word.nuanceNote != null && card.word.nuanceNote!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: AppColors.warning, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Nuance: ${card.word.nuanceNote!}',
                      style: const TextStyle(color: AppColors.darkTextSecondary, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRevealButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _flipToReveal,
        icon: const Icon(Icons.flip, color: Colors.white),
        label: const Text(
          'Reveal Dictionary Definition',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildRatingButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Rate your recall precision:',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.darkTextSecondary, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildGradeButton(
                grade: 1,
                label: 'Again',
                subtitle: 'Missed',
                color: AppColors.wrong,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildGradeButton(
                grade: 2,
                label: 'Hard',
                subtitle: 'Vague',
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildGradeButton(
                grade: 3,
                label: 'Good',
                subtitle: 'Got gist',
                color: const Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildGradeButton(
                grade: 4,
                label: 'Easy',
                subtitle: 'Accurate',
                color: AppColors.correct,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildGradeButton(
                grade: 5,
                label: 'Perfect',
                subtitle: 'Mastered',
                color: const Color(0xFF10B981),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGradeButton({
    required int grade,
    required String label,
    required String subtitle,
    required Color color,
  }) {
    return InkWell(
      onTap: () => _rateCard(grade),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              subtitle,
              style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
