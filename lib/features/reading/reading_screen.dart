import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../app/theme.dart';
import '../../core/audio/audio_service.dart';
import '../../core/db/database.dart';
import '../../app/providers.dart';
import '../games/widgets/what_you_learned_screen.dart';

class ReadingScreen extends ConsumerStatefulWidget {
  const ReadingScreen({super.key});

  @override
  ConsumerState<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends ConsumerState<ReadingScreen> {
  List<Passage> _passages = [];
  final int _currentIndex = 0;
  List<Question> _questions = [];
  bool _isLoading = true;

  int _selectedQuestionIndex = 0;
  String? _selectedOption;
  bool _hasAnswered = false;
  int _correctCount = 0;

  int _roundStartTime = 0;
  final List<LearnedItem> _learnedItems = [];

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadPassages();
  }

  Future<void> _loadPassages() async {
    final gameDao = ref.read(gameDaoProvider);
    final all = await gameDao.getAllPassages();
    if (!mounted) return;

    if (all.isNotEmpty) {
      final passage = all.first;
      final qs = await gameDao.getQuestionsForPassage(passage.id);
      setState(() {
        _passages = all;
        _questions = qs;
        _isLoading = false;
      });
    }
  }

  void _showWordLookup(String word) async {
    final clean = word.replaceAll(RegExp(r'[^a-zA-Z]'), '').toLowerCase();
    if (clean.isEmpty) return;

    ref.read(audioServiceProvider).speakOrPlay(clean);
    final wordDao = ref.read(wordDaoProvider);
    final found = await wordDao.getWordByLemma(clean);

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    found?.lemma ?? clean,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent),
                    onPressed: () => ref.read(audioServiceProvider).speakOrPlay(found?.lemma ?? clean),
                  ),
                ],
              ),
              if (found?.ipa != null)
                Text(
                  found!.ipa!,
                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              const SizedBox(height: 12),
              Text(
                found?.definitionEn ?? 'Word recognized in reading context.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.bookmark_add_rounded),
                label: const Text('Save to "From the Wild"'),
                onPressed: () async {
                  await ref.read(databaseProvider).into(ref.read(databaseProvider).wildItems).insert(
                        WildItemsCompanion.insert(
                          wordId: drift.Value(found?.id),
                          sentence: clean,
                          source: const drift.Value('Reading Passage'),
                          savedAt: DateTime.now().millisecondsSinceEpoch,
                        ),
                      );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Saved "$clean" to your Wild Words list!'),
                        backgroundColor: AppColors.correct,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitAnswer() {
    if (_selectedOption == null || _hasAnswered) return;
    final currentQ = _questions[_selectedQuestionIndex];
    final isCorrect = (_selectedOption == currentQ.answer);

    setState(() {
      _hasAnswered = true;
    });

    if (isCorrect) {
      _correctCount++;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
    }
  }

  void _nextQuestion() {
    if (_selectedQuestionIndex + 1 < _questions.length) {
      setState(() {
        _selectedQuestionIndex++;
        _selectedOption = null;
        _hasAnswered = false;
      });
    } else {
      _endReadingSession();
    }
  }

  Future<void> _endReadingSession() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final durationMs = now - _roundStartTime;
    final accuracy = _questions.isEmpty ? 1.0 : _correctCount / _questions.length;
    final score = (_correctCount * 100);

    final currentPassage = _passages[_currentIndex];
    _learnedItems.add(
      LearnedItem(
        term: currentPassage.title,
        definition: 'Passage (${currentPassage.wordCount} words) - CEFR ${currentPassage.cefr ?? "B1"}',
        example: 'Completed with ${(_correctCount)}/${_questions.length} quiz accuracy.',
        wasMistake: accuracy < 0.7,
      ),
    );

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'reading_passage',
            mode: const drift.Value('comprehension'),
            level: const drift.Value(2),
            startedAt: _roundStartTime,
            durationMs: durationMs,
            accuracy: accuracy,
            score: score,
            xpEarned: score ~/ 2,
          ),
        );

    final today = DateTime.now();
    final todayKey =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await ref.read(statsDaoProvider).recordDailyActivity(
          dayKey: todayKey,
          minutes: (durationMs / 60000).ceil(),
          xp: score ~/ 2,
          itemsReviewed: _questions.length,
          goalMet: true,
        );

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WhatYouLearnedScreen(
          gameTitle: '📖 Graded Reader',
          score: score,
          xpEarned: score ~/ 2,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ReadingScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _passages.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final passage = _passages[_currentIndex];
    final words = passage.body.split(RegExp(r'\s+'));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(passage.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent),
            onPressed: () => ref.read(audioServiceProvider).speakOrPlay(passage.body),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Passage Body with Tap-to-Define
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 6,
                  children: words.map((w) {
                    return GestureDetector(
                      onTap: () => _showWordLookup(w),
                      child: Text(
                        '$w ',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          height: 1.6,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const Divider(height: 1),

            // Comprehension Quiz Section
            if (_questions.isNotEmpty)
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: theme.colorScheme.surface,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Question ${_selectedQuestionIndex + 1}/${_questions.length}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _questions[_selectedQuestionIndex].prompt,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        const SizedBox(height: 10),

                        // Options
                        if (_questions[_selectedQuestionIndex].options != null) ...[
                          for (final opt in (json.decode(_questions[_selectedQuestionIndex].options!) as List<dynamic>))
                            RadioListTile<String>(
                              title: Text(opt as String),
                              value: opt,
                              groupValue: _selectedOption,
                              onChanged: _hasAnswered ? null : (val) => setState(() => _selectedOption = val),
                            ),
                        ],

                        if (_hasAnswered && _questions[_selectedQuestionIndex].explanation != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              '💡 ${_questions[_selectedQuestionIndex].explanation!}',
                              style: const TextStyle(fontStyle: FontStyle.italic, color: AppColors.accent),
                            ),
                          ),

                        const SizedBox(height: 8),
                        if (!_hasAnswered)
                          ElevatedButton(
                            onPressed: _selectedOption != null ? _submitAnswer : null,
                            child: const Text('Check Answer'),
                          )
                        else
                          ElevatedButton(
                            onPressed: _nextQuestion,
                            child: Text(_selectedQuestionIndex + 1 < _questions.length
                                ? 'Next Question'
                                : 'Complete Reading'),
                          ),
                      ],
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
