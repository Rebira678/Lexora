import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../widgets/what_you_learned_screen.dart';

enum XRayTagMode { subject, verb, extras }

class SentenceXRayScreen extends ConsumerStatefulWidget {
  final int level;

  const SentenceXRayScreen({
    super.key,
    this.level = 2,
  });

  @override
  ConsumerState<SentenceXRayScreen> createState() => _SentenceXRayScreenState();
}

class _SentenceXRayScreenState extends ConsumerState<SentenceXRayScreen> {
  List<SentenceStructure> _sentences = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  XRayTagMode _activeTag = XRayTagMode.subject;
  final Set<int> _selectedSubject = {};
  final Set<int> _selectedVerb = {};
  final Set<int> _selectedExtras = {};

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
    _loadSentences();
  }

  Future<void> _loadSentences() async {
    final gameDao = ref.read(gameDaoProvider);
    final list = await gameDao.getSentencesForLevel(widget.level);
    if (!mounted) return;

    if (list.isNotEmpty) {
      setState(() {
        _sentences = List.of(list)..shuffle();
        _isLoading = false;
      });
    } else {
      final all = await ref.read(databaseProvider).select(ref.read(databaseProvider).sentenceStructures).get();
      setState(() {
        _sentences = List.of(all)..shuffle();
        _isLoading = false;
      });
    }

    if (_sentences.isNotEmpty) {
      _resetSelection();
    }
  }

  void _resetSelection() {
    setState(() {
      _selectedSubject.clear();
      _selectedVerb.clear();
      _selectedExtras.clear();
      _activeTag = XRayTagMode.subject;
      _hasChecked = false;
    });
  }

  void _onWordTap(int index) {
    if (_hasChecked) return;
    setState(() {
      // Toggle or switch category
      _selectedSubject.remove(index);
      _selectedVerb.remove(index);
      _selectedExtras.remove(index);

      switch (_activeTag) {
        case XRayTagMode.subject:
          _selectedSubject.add(index);
          break;
        case XRayTagMode.verb:
          _selectedVerb.add(index);
          break;
        case XRayTagMode.extras:
          _selectedExtras.add(index);
          break;
      }
    });
  }

  void _checkBreakdown() {
    final current = _sentences[_currentIndex];
    // Check subject & verb identification
    bool isGood = _selectedSubject.isNotEmpty && _selectedVerb.isNotEmpty;

    setState(() {
      _hasChecked = true;
    });

    if (isGood) {
      _correctCount++;
      _score += 150;
      _xpEarned += 30;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay(current.sentence);

      _learnedItems.add(
        LearnedItem(
          term: current.sentence,
          definition: current.simpleMeaning ?? 'Deconstructed English core sentence',
          example: 'Subject & Main Verb identified successfully',
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);

      _learnedItems.add(
        LearnedItem(
          term: current.sentence,
          definition: current.simpleMeaning ?? 'Deconstructed English core sentence',
          example: 'Review subject and verb identification',
          wasMistake: true,
        ),
      );
    }
  }

  void _nextSentence() {
    if (_currentIndex + 1 < _sentences.length && _currentIndex + 1 < 8) {
      setState(() {
        _currentIndex++;
        _resetSelection();
      });
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
            game: 'sentence_xray',
            mode: const drift.Value('core_finding'),
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
          gameTitle: '🔬 Sentence X-Ray',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => SentenceXRayScreen(level: widget.level)),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _sentences.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final current = _sentences[_currentIndex];
    final words = current.sentence.split(' ');
    final maxSentences = _sentences.length < 8 ? _sentences.length : 8;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sentence X-Ray (${_currentIndex + 1}/$maxSentences)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent),
            onPressed: () => ref.read(audioServiceProvider).speakOrPlay(current.sentence),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tag Selector Bar
              SegmentedButton<XRayTagMode>(
                segments: const [
                  ButtonSegment(value: XRayTagMode.subject, label: Text('Subject')),
                  ButtonSegment(value: XRayTagMode.verb, label: Text('Main Verb')),
                  ButtonSegment(value: XRayTagMode.extras, label: Text('Extras')),
                ],
                selected: {_activeTag},
                onSelectionChanged: (set) {
                  setState(() => _activeTag = set.first);
                },
              ),
              const SizedBox(height: 16),

              // Interactive Sentence Word Area
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent.withAlpha(60)),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: List.generate(words.length, (index) {
                      Color bgColor = theme.colorScheme.surfaceContainerHighest;
                      Color textColor = theme.colorScheme.onSurface;

                      if (_selectedSubject.contains(index)) {
                        bgColor = Colors.blue.withAlpha(80);
                        textColor = Colors.blue.shade200;
                      } else if (_selectedVerb.contains(index)) {
                        bgColor = Colors.red.withAlpha(80);
                        textColor = Colors.red.shade200;
                      } else if (_selectedExtras.contains(index)) {
                        bgColor = Colors.amber.withAlpha(80);
                        textColor = Colors.amber.shade200;
                      }

                      return InkWell(
                        onTap: () => _onWordTap(index),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: bgColor == theme.colorScheme.surfaceContainerHighest
                                  ? Colors.transparent
                                  : textColor,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            words[index],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Breakdown Explanation when checked
              if (_hasChecked)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('💡 X-Ray Core Breakdown', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('Core Subject: ${current.subjectSpan ?? "Target Subject"}'),
                      Text('Core Verb: ${current.verbSpan ?? "Target Action"}'),
                      if (current.simpleMeaning != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Simple Paraphrase: ${current.simpleMeaning}',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Bottom Action Button
              if (!_hasChecked)
                ElevatedButton(
                  onPressed: (_selectedSubject.isNotEmpty || _selectedVerb.isNotEmpty)
                      ? _checkBreakdown
                      : null,
                  child: const Text('Analyze Sentence'),
                )
              else
                ElevatedButton(
                  onPressed: _nextSentence,
                  child: Text(_currentIndex + 1 < 4 ? 'Next Sentence' : 'Finish Round'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
