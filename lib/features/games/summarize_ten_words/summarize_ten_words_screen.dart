import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/planner/difficulty_tuner.dart';
import '../widgets/what_you_learned_screen.dart';

class SummarizeTenWordsScreen extends ConsumerStatefulWidget {
  final int level;

  const SummarizeTenWordsScreen({
    super.key,
    this.level = 4,
  });

  @override
  ConsumerState<SummarizeTenWordsScreen> createState() => _SummarizeTenWordsScreenState();
}

class _SummarizeTenWordsScreenState extends ConsumerState<SummarizeTenWordsScreen> {
  List<SentenceStructure> _sentences = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  final TextEditingController _summaryController = TextEditingController();
  int _currentWordCount = 0;
  bool _showClue = false;
  bool _hasChecked = false;
  double _lastScorePercentage = 0.0;
  String _teacherFeedback = '';

  int _score = 0;
  int _xpEarned = 0;
  int _correctCount = 0;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _summaryController.addListener(_onTextChanged);
    _loadSentences();
  }

  @override
  void dispose() {
    _summaryController.removeListener(_onTextChanged);
    _summaryController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _summaryController.text.trim();
    final words = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
    if (words != _currentWordCount) {
      setState(() {
        _currentWordCount = words;
      });
    }
  }

  Future<void> _loadSentences() async {
    final db = ref.read(databaseProvider);
    final all = await (db.select(db.sentenceStructures)
          ..where((tbl) => tbl.level.isBiggerOrEqualValue(widget.level))
          ..limit(15))
        .get();

    if (!mounted) return;

    if (all.isNotEmpty) {
      setState(() {
        _sentences = List.of(all)..shuffle();
        _isLoading = false;
      });
    } else {
      final fallback = await db.select(db.sentenceStructures).get();
      setState(() {
        _sentences = List.of(fallback)..shuffle();
        _isLoading = false;
      });
    }
  }

  void _evaluateSummary() {
    if (_hasChecked || _currentWordCount == 0) return;

    final current = _sentences[_currentIndex];
    final userSummary = _summaryController.text.trim();
    final benchmark = (current.simpleMeaning ?? current.sentence).trim();

    // 1. Length constraint: must be <= 10 words.
    final lengthPenalty = _currentWordCount > 10 ? (_currentWordCount - 10) * 0.15 : 0.0;

    // 2. Token overlap with simpleMeaning & sentence root
    final userTokens = userSummary
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(RegExp(r'\s+'))
        .where((t) => t.length > 2)
        .toSet();

    final benchmarkTokens = benchmark
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(RegExp(r'\s+'))
        .where((t) => t.length > 2)
        .toSet();

    final overlap = userTokens.intersection(benchmarkTokens).length;
    final maxTokens = benchmarkTokens.isEmpty ? 1 : benchmarkTokens.length;
    final recall = (overlap / maxTokens).clamp(0.0, 1.0);

    // Subject/Verb anchor presence check
    double anchorBonus = 0.0;
    if (current.subjectSpan != null && current.subjectSpan!.isNotEmpty) {
      final words = current.sentence.split(' ');
      final parts = current.subjectSpan!.split('-');
      final start = int.tryParse(parts[0]) ?? 0;
      final end = parts.length > 1 ? (int.tryParse(parts[1]) ?? start) : start;
      for (int i = start; i <= end && i < words.length; i++) {
        final subWord = words[i].replaceAll(RegExp(r'[^\w]'), '').toLowerCase();
        if (subWord.length > 3 && userTokens.contains(subWord)) {
          anchorBonus += 0.2;
          break;
        }
      }
    }

    final rawScore = ((recall * 0.7) + anchorBonus - lengthPenalty).clamp(0.0, 1.0);
    _lastScorePercentage = rawScore;

    final isSuccess = rawScore >= 0.45 && _currentWordCount <= 10;

    if (isSuccess) {
      _score += (rawScore * 200).round();
      _xpEarned += 30;
      _correctCount++;
      AudioService().playSfx(SfxType.correct);
      _teacherFeedback = _currentWordCount <= 7
          ? 'Exceptional conciseness! You captured the essential proposition in under 8 words.'
          : 'Great synthesis! The core subject and predicate are cleanly distilled.';
    } else {
      AudioService().playSfx(SfxType.wrong);
      if (_currentWordCount > 10) {
        _teacherFeedback =
            'Word limit exceeded ($_currentWordCount/10). Discard subordinate details and focus strictly on Subject + Action.';
      } else {
        _teacherFeedback =
            'Missed core predicate. Compare your summary with the model distillation below to see how clauses were collapsed.';
      }
    }

    _learnedItems.add(
      LearnedItem(
        term: userSummary,
        definition: 'Model: $benchmark',
        example: current.sentence,
        wasMistake: !isSuccess,
      ),
    );

    setState(() {
      _hasChecked = true;
    });
  }

  void _nextSentence() {
    if (_currentIndex < _sentences.length - 1) {
      setState(() {
        _currentIndex++;
        _summaryController.clear();
        _currentWordCount = 0;
        _showClue = false;
        _hasChecked = false;
      });
    } else {
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    final total = _sentences.isEmpty ? 1 : _sentences.length;
    final accuracy = _correctCount / total;
    final durationMs = DateTime.now().millisecondsSinceEpoch - _roundStartTime;

    final nextLevel = nextSentenceLevel(widget.level, accuracy, 1);

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'summarize_ten_words',
            mode: const drift.Value('core_condensation'),
            level: drift.Value(widget.level),
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
          gameTitle: '📝 Summarize in 10 Words (Level ${widget.level})',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => SummarizeTenWordsScreen(level: nextLevel)),
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

    if (_sentences.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.darkBg,
        appBar: AppBar(title: const Text('Summarize in 10 Words')),
        body: const Center(
          child: Text('No sentences available for this level.',
              style: TextStyle(color: AppColors.darkTextSecondary)),
        ),
      );
    }

    final current = _sentences[_currentIndex];
    final progress = (_currentIndex + 1) / _sentences.length;

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
              'Summarize in 10 Words',
              style: TextStyle(color: AppColors.darkText, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Sentence ${_currentIndex + 1}/${_sentences.length} • Level ${current.level}',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header meta info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.darkSurface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.darkBorder),
                          ),
                          child: Text(
                            'Original: ${current.wordCount} words',
                            style: const TextStyle(color: AppColors.darkTextSecondary, fontSize: 12),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up, color: AppColors.darkTextSecondary),
                          onPressed: () => AudioService().speakOrPlay(current.sentence),
                          tooltip: 'Listen to sentence',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Long Sentence Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.darkBorder),
                      ),
                      child: Text(
                        current.sentence,
                        style: const TextStyle(
                          color: AppColors.darkText,
                          fontSize: 16,
                          height: 1.5,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Clue button
                    if (!_hasChecked)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => setState(() => _showClue = !_showClue),
                          icon: Icon(
                            _showClue ? Icons.visibility_off : Icons.lightbulb,
                            size: 16,
                            color: AppColors.warning,
                          ),
                          label: Text(
                            _showClue ? 'Hide Core Clue' : 'Show Core Clue (Subject & Verb)',
                            style: const TextStyle(color: AppColors.warning, fontSize: 13),
                          ),
                        ),
                      ),

                    if (_showClue && !_hasChecked)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          'Core Idea Anchor: ${current.simpleMeaning ?? "Focus on WHO did WHAT, ignoring extra clauses."}',
                          style: const TextStyle(color: AppColors.darkText, fontSize: 13),
                        ),
                      ),

                    // Word count indicator chip
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Summary (≤ 10 words):',
                          style: TextStyle(
                            color: AppColors.darkTextSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _currentWordCount > 10
                                ? AppColors.wrong.withValues(alpha: 0.2)
                                : (_currentWordCount > 0 ? AppColors.correct.withValues(alpha: 0.2) : AppColors.darkSurface),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _currentWordCount > 10
                                  ? AppColors.wrong
                                  : (_currentWordCount > 0 ? AppColors.correct : AppColors.darkBorder),
                            ),
                          ),
                          child: Text(
                            '$_currentWordCount / 10 words',
                            style: TextStyle(
                              color: _currentWordCount > 10
                                  ? AppColors.wrong
                                  : (_currentWordCount > 0 ? AppColors.correct : AppColors.darkTextSecondary),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Input Field
                    TextField(
                      controller: _summaryController,
                      enabled: !_hasChecked,
                      maxLines: 3,
                      style: const TextStyle(color: AppColors.darkText, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Condense into the single most important message...',
                        hintStyle: const TextStyle(color: AppColors.darkTextSecondary),
                        filled: true,
                        fillColor: AppColors.darkSurface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.darkBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _currentWordCount > 10 ? AppColors.wrong : AppColors.accent,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Teacher Feedback section if checked
                    if (_hasChecked) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (_lastScorePercentage >= 0.45 && _currentWordCount <= 10)
                              ? AppColors.correct.withValues(alpha: 0.1)
                              : AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (_lastScorePercentage >= 0.45 && _currentWordCount <= 10)
                                ? AppColors.correct.withValues(alpha: 0.3)
                                : AppColors.warning.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  (_lastScorePercentage >= 0.45 && _currentWordCount <= 10)
                                      ? Icons.verified
                                      : Icons.info_outline,
                                  color: (_lastScorePercentage >= 0.45 && _currentWordCount <= 10)
                                      ? AppColors.correct
                                      : AppColors.warning,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Teacher Feedback (${(_lastScorePercentage * 100).round()}% match)',
                                  style: const TextStyle(
                                    color: AppColors.darkText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _teacherFeedback,
                              style: const TextStyle(color: AppColors.darkTextSecondary, fontSize: 13, height: 1.4),
                            ),
                            const Divider(color: AppColors.darkBorder, height: 24),
                            const Text(
                              'Senior Teacher Benchmark:',
                              style: TextStyle(
                                color: AppColors.warning,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              current.simpleMeaning ?? current.sentence,
                              style: const TextStyle(
                                color: AppColors.darkText,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
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
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _currentWordCount == 0
                      ? null
                      : _hasChecked
                          ? _nextSentence
                          : _evaluateSummary,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    disabledBackgroundColor: AppColors.darkBorder,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _hasChecked
                        ? (_currentIndex < _sentences.length - 1 ? 'Next Sentence ➔' : 'Complete Gym ➔')
                        : 'Submit Summary',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
