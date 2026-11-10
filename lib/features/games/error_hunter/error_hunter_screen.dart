import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/services/phase2_content_service.dart';
import '../widgets/what_you_learned_screen.dart';

class ErrorItem {
  final int id;
  final String sentence;
  final String errorWord;
  final String correction;
  final int errorIndex;
  final String category;
  final String explanation;

  ErrorItem({
    required this.id,
    required this.sentence,
    required this.errorWord,
    required this.correction,
    required this.errorIndex,
    required this.category,
    required this.explanation,
  });

  factory ErrorItem.fromJson(Map<String, dynamic> json) {
    return ErrorItem(
      id: json['id'] as int,
      sentence: json['sentence'] as String,
      errorWord: json['errorWord'] as String,
      correction: json['correction'] as String,
      errorIndex: json['errorIndex'] as int,
      category: json['category'] as String,
      explanation: json['explanation'] as String,
    );
  }
}

class ErrorHunterScreen extends ConsumerStatefulWidget {
  const ErrorHunterScreen({super.key});

  @override
  ConsumerState<ErrorHunterScreen> createState() => _ErrorHunterScreenState();
}

class _ErrorHunterScreenState extends ConsumerState<ErrorHunterScreen> {
  List<ErrorItem> _items = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  int? _selectedWordIndex;
  bool _hasHunted = false;
  bool _isFound = false;

  int _score = 0;
  int _xpEarned = 0;
  int _correctCount = 0;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final data = await Phase2ContentService.instance.loadContent();
      final list = (data['error_hunter'] as List)
          .map((e) => ErrorItem.fromJson(e as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _items = list..shuffle();
        _isLoading = false;
      });

      if (_items.isNotEmpty) {
        _speakSentence();
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _speakSentence() {
    if (_currentIndex < _items.length) {
      ref.read(audioServiceProvider).speakOrPlay(_items[_currentIndex].sentence);
    }
  }

  void _onWordTap(int index) {
    if (_hasHunted) return;
    setState(() => _selectedWordIndex = index);
  }

  void _huntError() {
    if (_selectedWordIndex == null || _hasHunted) return;
    final current = _items[_currentIndex];
    final words = current.sentence.split(RegExp(r'\s+'));
    final tappedWord = words[_selectedWordIndex!].replaceAll(RegExp(r'[^\w]'), '');
    final errorTarget = current.errorWord.replaceAll(RegExp(r'[^\w]'), '');

    final isFound = (_selectedWordIndex == current.errorIndex) ||
        (tappedWord.toLowerCase() == errorTarget.toLowerCase());

    setState(() {
      _hasHunted = true;
      _isFound = isFound;
    });

    final correctedSentence = current.sentence.replaceFirst(current.errorWord, current.correction);

    if (isFound) {
      _correctCount++;
      _score += 150;
      _xpEarned += 30;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay(correctedSentence);

      _learnedItems.add(
        LearnedItem(
          term: '${current.category}: "${current.errorWord}" ➔ "${current.correction}"',
          definition: current.explanation,
          example: correctedSentence,
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);

      _learnedItems.add(
        LearnedItem(
          term: '${current.category}: "${current.errorWord}" ➔ "${current.correction}"',
          definition: current.explanation,
          example: correctedSentence,
          wasMistake: true,
        ),
      );
    }
  }

  void _next() {
    if (_currentIndex + 1 < _items.length && _currentIndex + 1 < 4) {
      setState(() {
        _currentIndex++;
        _selectedWordIndex = null;
        _hasHunted = false;
        _isFound = false;
      });
      _speakSentence();
    } else {
      _endGame();
    }
  }

  Future<void> _endGame() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final durationMs = now - _roundStartTime;
    final total = _currentIndex + 1;
    final accuracy = total == 0 ? 0.0 : _correctCount / total;

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'error_hunter',
            mode: const drift.Value('proofreading'),
            level: const drift.Value(3),
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
          gameTitle: '🦅 Error Hunter',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ErrorHunterScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error Hunter')),
        body: const Center(child: Text('No sentences available.')),
      );
    }

    final theme = Theme.of(context);
    final current = _items[_currentIndex];
    final words = current.sentence.split(RegExp(r'\s+'));
    final total = _items.length < 4 ? _items.length : 4;

    return Scaffold(
      appBar: AppBar(
        title: Text('Error Hunter (${_currentIndex + 1}/$total)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent),
            tooltip: 'Hear Sentence',
            onPressed: _speakSentence,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Instruction Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, size: 20, color: AppColors.accent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _hasHunted
                            ? (_isFound ? 'Eagle eye! Error captured.' : 'Error missed. Review grammar rule below.')
                            : 'A hidden grammar or collocation error is in this sentence. Tap the faulty word!',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _hasHunted
                              ? (_isFound ? AppColors.correct : AppColors.wrong)
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Interactive Token Sentence Area
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: List.generate(words.length, (index) {
                        final word = words[index];
                        final isSelected = _selectedWordIndex == index;
                        final isActualError = (index == current.errorIndex) ||
                            (word.replaceAll(RegExp(r'[^\w]'), '').toLowerCase() ==
                                current.errorWord.replaceAll(RegExp(r'[^\w]'), '').toLowerCase());

                        Color borderColor = Colors.transparent;
                        Color bgColor = theme.colorScheme.surfaceContainerHighest.withAlpha(120);
                        Color textColor = theme.colorScheme.onSurface;

                        if (!_hasHunted) {
                          if (isSelected) {
                            borderColor = theme.colorScheme.primary;
                            bgColor = theme.colorScheme.primary.withAlpha(30);
                            textColor = theme.colorScheme.primary;
                          }
                        } else {
                          if (isActualError) {
                            borderColor = AppColors.correct;
                            bgColor = AppColors.correct.withAlpha(30);
                            textColor = AppColors.correct;
                          } else if (isSelected && !isActualError) {
                            borderColor = AppColors.wrong;
                            bgColor = AppColors.wrong.withAlpha(30);
                            textColor = AppColors.wrong;
                          }
                        }

                        return InkWell(
                          onTap: () => _onWordTap(index),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: borderColor, width: 1.5),
                            ),
                            child: Text(
                              word,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected || (_hasHunted && isActualError) ? FontWeight.bold : FontWeight.normal,
                                color: textColor,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Explanation & Correction when checked
              if (_hasHunted)
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.verified_rounded, size: 18, color: AppColors.correct),
                          const SizedBox(width: 8),
                          Text(
                            'Correction: "${current.errorWord}" ➔ "${current.correction}"',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.correct),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        current.explanation,
                        style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant, height: 1.3),
                      ),
                    ],
                  ),
                ),

              // Action button
              if (!_hasHunted)
                ElevatedButton(
                  onPressed: _selectedWordIndex != null ? _huntError : null,
                  child: const Text('Capture Faulty Word'),
                )
              else
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_currentIndex + 1 < total ? 'Next Sentence' : 'Finish Error Hunt'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
