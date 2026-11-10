import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/audio/audio_service.dart';
import '../../../app/providers.dart';
import '../../../core/db/database.dart';
import '../../../core/services/phase4_content_service.dart';
import '../widgets/what_you_learned_screen.dart';

class NuanceDuelItem {
  final int id;
  final String context;
  final String wordA;
  final String wordB;
  final String correct;
  final String nuanceExplanation;
  final String cefr;
  final String collocation;

  const NuanceDuelItem({
    required this.id,
    required this.context,
    required this.wordA,
    required this.wordB,
    required this.correct,
    required this.nuanceExplanation,
    required this.cefr,
    required this.collocation,
  });

  factory NuanceDuelItem.fromJson(Map<String, dynamic> json) {
    return NuanceDuelItem(
      id: json['id'] as int? ?? 0,
      context: json['context'] as String? ?? '',
      wordA: json['wordA'] as String? ?? '',
      wordB: json['wordB'] as String? ?? '',
      correct: json['correct'] as String? ?? '',
      nuanceExplanation: json['nuanceExplanation'] as String? ?? '',
      cefr: json['cefr'] as String? ?? 'C1',
      collocation: json['collocation'] as String? ?? '',
    );
  }
}

class NuanceDuelScreen extends ConsumerStatefulWidget {
  const NuanceDuelScreen({super.key});

  @override
  ConsumerState<NuanceDuelScreen> createState() => _NuanceDuelScreenState();
}

class _NuanceDuelScreenState extends ConsumerState<NuanceDuelScreen> {
  List<NuanceDuelItem> _items = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  String? _selectedWord;
  bool _hasChecked = false;
  bool _isCorrect = false;

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
    try {
      final data = await Phase4ContentService.instance.loadContent();
      final list = (data['nuance_duel'] as List)
          .map((i) => NuanceDuelItem.fromJson(i as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _items = list;
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
      ref.read(audioServiceProvider).speakOrPlay(_items[_currentIndex].context);
    }
  }

  void _selectWord(String word) {
    if (_hasChecked) return;
    setState(() => _selectedWord = word);
  }

  void _checkAnswer() {
    if (_selectedWord == null || _hasChecked) return;

    final item = _items[_currentIndex];
    final isCorrect = _selectedWord!.trim().toLowerCase() == item.correct.trim().toLowerCase();

    setState(() {
      _hasChecked = true;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      _score += 150;
      _xpEarned += 25;
      _correctCount++;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
    }

    _learnedItems.add(
      LearnedItem(
        term: '${item.correct} vs ${_selectedWord == item.wordA ? item.wordB : item.wordA}',
        definition: item.nuanceExplanation,
        example: item.context,
        wasMistake: !isCorrect,
      ),
    );
  }

  void _next() {
    if (_currentIndex + 1 < _items.length) {
      setState(() {
        _currentIndex++;
        _selectedWord = null;
        _hasChecked = false;
        _isCorrect = false;
      });
      _speakSentence();
    } else {
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    final durationMs = DateTime.now().millisecondsSinceEpoch - _roundStartTime;
    final total = _items.isNotEmpty ? _items.length : 1;
    final accuracy = _correctCount / total;

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'nuance_duel',
            mode: const drift.Value('c1_precision'),
            level: const drift.Value(4),
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
          gameTitle: '⚖️ Nuance Duel (Semantic Precision)',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const NuanceDuelScreen()),
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
        backgroundColor: Color(0xFF0A0C10),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF6366F1)),
        ),
      );
    }

    if (_items.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0C10),
        appBar: AppBar(title: const Text('Nuance Duel')),
        body: const Center(
          child: Text('No nuance duels available.', style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    final item = _items[_currentIndex];
    final total = _items.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12161F),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nuance Duel: Semantic Precision',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'Duel ${_currentIndex + 1} of $total • Near-Synonym Choice',
              style: const TextStyle(fontSize: 12, color: Color(0xFF818CF8)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF6366F1)),
            tooltip: 'Read Context Sentence',
            onPressed: _speakSentence,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: (_currentIndex + 1) / total,
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation(Color(0xFF6366F1)),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 18),

              // Context Sentence Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF12161F),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withAlpha(40),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'CEFR ${item.cefr} CONTEXT',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF818CF8),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.compare_arrows_rounded, color: Color(0xFF6366F1), size: 18),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      item.context,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Select the word with the precise contextual connotation:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),

              // Dual Choice Cards
              Row(
                children: [
                  Expanded(child: _buildDuelCard(item.wordA, item)),
                  const SizedBox(width: 14),
                  Expanded(child: _buildDuelCard(item.wordB, item)),
                ],
              ),
              const SizedBox(height: 24),

              // Detailed Pedagogical Feedback (if checked)
              if (_hasChecked) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isCorrect
                        ? const Color(0xFF10B981).withAlpha(20)
                        : const Color(0xFFEF4444).withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isCorrect ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                            color: _isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isCorrect ? 'Accurate Precision (+150 pts)' : 'Nuance Distinction',
                            style: TextStyle(
                              color: _isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.nuanceExplanation,
                        style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Collocation Anchor: ',
                              style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              item.collocation,
                              style: const TextStyle(color: Color(0xFF818CF8), fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Action Button
              if (!_hasChecked)
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _selectedWord != null ? _checkAnswer : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      disabledBackgroundColor: Colors.white10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Confirm Lexical Choice',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      _currentIndex + 1 < total ? 'Next Duel' : 'Complete Duel Session',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDuelCard(String word, NuanceDuelItem item) {
    final isSelected = _selectedWord == word;
    final isTargetCorrect = word.trim().toLowerCase() == item.correct.trim().toLowerCase();

    Color borderColor = Colors.white24;
    Color bgColor = const Color(0xFF161B26);

    if (_hasChecked) {
      if (isTargetCorrect) {
        borderColor = const Color(0xFF10B981);
        bgColor = const Color(0xFF10B981).withAlpha(25);
      } else if (isSelected) {
        borderColor = const Color(0xFFEF4444);
        bgColor = const Color(0xFFEF4444).withAlpha(25);
      }
    } else if (isSelected) {
      borderColor = const Color(0xFF6366F1);
      bgColor = const Color(0xFF6366F1).withAlpha(30);
    }

    return InkWell(
      onTap: () => _selectWord(word),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Center(
          child: Text(
            word,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
