import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/planner/difficulty_tuner.dart';
import '../../../core/services/section20_content_service.dart';
import '../widgets/what_you_learned_screen.dart';

class ReferenceHunterScreen extends ConsumerStatefulWidget {
  final int level;

  const ReferenceHunterScreen({
    super.key,
    this.level = 4,
  });

  @override
  ConsumerState<ReferenceHunterScreen> createState() => _ReferenceHunterScreenState();
}

class _ReferenceHunterScreenState extends ConsumerState<ReferenceHunterScreen> {
  final Section20ContentService _contentService = Section20ContentService();
  List<ReferenceHunterItem> _items = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  int? _selectedOptionIndex;
  bool _hasChecked = false;
  int _score = 0;
  int _xpEarned = 0;
  int _correctCount = 0;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadData();
  }

  Future<void> _loadData() async {
    final list = await _contentService.getReferenceItems(level: widget.level);
    if (!mounted) return;
    setState(() {
      _items = List.of(list)..shuffle();
      _isLoading = false;
    });
  }

  void _onSelectOption(int index) {
    if (_hasChecked) return;
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  void _checkAnswer() {
    if (_selectedOptionIndex == null || _hasChecked) return;

    final current = _items[_currentIndex];
    final isCorrect = _selectedOptionIndex == current.correctOptionIndex;

    if (isCorrect) {
      _score += 150;
      _xpEarned += 25;
      _correctCount++;
      AudioService().playSfx(SfxType.correct);
    } else {
      AudioService().playSfx(SfxType.wrong);
    }

    _learnedItems.add(
      LearnedItem(
        term: '${current.pronoun} ➔ ${current.antecedent}',
        definition: current.explanation,
        example: current.sentence,
        wasMistake: !isCorrect,
      ),
    );

    setState(() {
      _hasChecked = true;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _items.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
        _hasChecked = false;
      });
    } else {
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    final total = _items.isEmpty ? 1 : _items.length;
    final accuracy = _correctCount / total;
    final durationMs = DateTime.now().millisecondsSinceEpoch - _roundStartTime;

    final nextLevel = nextSentenceLevel(widget.level, accuracy, 1);

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'reference_hunter',
            mode: const drift.Value('pronoun_tracking'),
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
          gameTitle: '🎯 Reference Hunter (Level ${widget.level})',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => ReferenceHunterScreen(level: nextLevel)),
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

    if (_items.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.darkBg,
        appBar: AppBar(title: const Text('Reference Hunter')),
        body: const Center(
          child: Text('No reference sentences available for this level.',
              style: TextStyle(color: AppColors.darkTextSecondary)),
        ),
      );
    }

    final item = _items[_currentIndex];
    final progress = (_currentIndex + 1) / _items.length;

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
              'Reference Hunter',
              style: TextStyle(color: AppColors.darkText, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Level ${widget.level} • Clause Logic',
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
                    // Question banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.radar, color: AppColors.accent, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(color: AppColors.darkText, fontSize: 15, height: 1.4),
                                children: [
                                  const TextSpan(text: 'What does the pronoun "'),
                                  TextSpan(
                                    text: item.pronoun,
                                    style: const TextStyle(
                                      color: AppColors.warning,
                                      fontWeight: FontWeight.bold,
                                      backgroundColor: Color(0x33F59E0B),
                                    ),
                                  ),
                                  const TextSpan(text: '" point back to?'),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.volume_up, color: AppColors.darkTextSecondary),
                            onPressed: () => AudioService().speakOrPlay(item.sentence),
                            tooltip: 'Listen to sentence',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sentence Card with highlighted target
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.darkBorder),
                      ),
                      child: _buildHighlightedSentence(item),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Select the Antecedent:',
                      style: TextStyle(
                        color: AppColors.darkTextSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Options list
                    ...List.generate(item.options.length, (idx) {
                      final option = item.options[idx];
                      final isSelected = _selectedOptionIndex == idx;
                      final isCorrect = idx == item.correctOptionIndex;

                      Color borderColor = AppColors.darkBorder;
                      Color bgColor = AppColors.darkSurface;
                      Color textColor = AppColors.darkText;

                      if (_hasChecked) {
                        if (isCorrect) {
                          borderColor = AppColors.correct;
                          bgColor = AppColors.correct.withValues(alpha: 0.15);
                          textColor = AppColors.correct;
                        } else if (isSelected && !isCorrect) {
                          borderColor = AppColors.wrong;
                          bgColor = AppColors.wrong.withValues(alpha: 0.15);
                          textColor = AppColors.wrong;
                        }
                      } else if (isSelected) {
                        borderColor = AppColors.accent;
                        bgColor = AppColors.accent.withValues(alpha: 0.15);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: _hasChecked ? null : () => _onSelectOption(idx),
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: borderColor),
                                    color: isSelected ? borderColor : Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      String.fromCharCode(65 + idx),
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : AppColors.darkTextSecondary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 15,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (_hasChecked && isCorrect)
                                  const Icon(Icons.check_circle, color: AppColors.correct, size: 22)
                                else if (_hasChecked && isSelected && !isCorrect)
                                  const Icon(Icons.cancel, color: AppColors.wrong, size: 22),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    if (_hasChecked) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (_selectedOptionIndex == item.correctOptionIndex)
                              ? AppColors.correct.withValues(alpha: 0.1)
                              : AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (_selectedOptionIndex == item.correctOptionIndex)
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
                                  (_selectedOptionIndex == item.correctOptionIndex)
                                      ? Icons.check_circle_outline
                                      : Icons.lightbulb_outline,
                                  color: (_selectedOptionIndex == item.correctOptionIndex)
                                      ? AppColors.correct
                                      : AppColors.warning,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Senior Teacher Analysis:',
                                  style: TextStyle(
                                    color: AppColors.darkText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.explanation,
                              style: const TextStyle(
                                color: AppColors.darkTextSecondary,
                                fontSize: 13,
                                height: 1.45,
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
                  onPressed: _selectedOptionIndex == null
                      ? null
                      : _hasChecked
                          ? _nextQuestion
                          : _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    disabledBackgroundColor: AppColors.darkBorder,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _hasChecked
                        ? (_currentIndex < _items.length - 1 ? 'Next Sentence ➔' : 'View Results ➔')
                        : 'Confirm Antecedent',
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

  Widget _buildHighlightedSentence(ReferenceHunterItem item) {
    final words = item.sentence.split(' ');
    final spans = <TextSpan>[];

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final cleanWord = word.replaceAll(RegExp(r'[^\w\s]'), '').toLowerCase();
      final targetClean = item.pronoun.toLowerCase();

      final isTargetPronoun = (i == item.pronounIndex) || (cleanWord == targetClean && words.length > 5);

      if (isTargetPronoun) {
        spans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(
              color: AppColors.warning,
              fontWeight: FontWeight.w900,
              backgroundColor: Color(0x33F59E0B),
              decoration: TextDecoration.underline,
              decorationColor: AppColors.warning,
              fontSize: 17,
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(
              color: AppColors.darkText,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        );
      }
    }

    return RichText(text: TextSpan(children: spans));
  }
}
