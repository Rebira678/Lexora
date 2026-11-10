import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/services/phase5_content_service.dart';
import '../widgets/what_you_learned_screen.dart';

class RhetoricalItem {
  final int id;
  final String author;
  final String work;
  final String excerpt;
  final String targetDevice;
  final String targetSpan;
  final List<String> options;
  final String explanation;

  RhetoricalItem({
    required this.id,
    required this.author,
    required this.work,
    required this.excerpt,
    required this.targetDevice,
    required this.targetSpan,
    required this.options,
    required this.explanation,
  });

  factory RhetoricalItem.fromJson(Map<String, dynamic> json) {
    return RhetoricalItem(
      id: json['id'] as int,
      author: json['author'] as String,
      work: json['work'] as String,
      excerpt: json['excerpt'] as String,
      targetDevice: json['targetDevice'] as String,
      targetSpan: json['targetSpan'] as String,
      options: List<String>.from(json['options'] as List),
      explanation: json['explanation'] as String,
    );
  }
}

class StyleAnalyzerScreen extends ConsumerStatefulWidget {
  const StyleAnalyzerScreen({super.key});

  @override
  ConsumerState<StyleAnalyzerScreen> createState() => _StyleAnalyzerScreenState();
}

class _StyleAnalyzerScreenState extends ConsumerState<StyleAnalyzerScreen> {
  List<RhetoricalItem> _items = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  String? _selectedDevice;
  bool _hasChecked = false;
  int _score = 0;
  final List<LearnedItem> _learnedItems = [];

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final data = await Phase5ContentService.instance.loadContent();
      final list = (data['rhetorical_analysis'] as List)
          .map((i) => RhetoricalItem.fromJson(i as Map<String, dynamic>))
          .toList();

      if (mounted) {
        setState(() {
          _items = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _verifyChoice(String choice) {
    if (_hasChecked) return;
    final audio = ref.read(audioServiceProvider);
    final current = _items[_currentIndex];
    final isCorrect = choice.toLowerCase() == current.targetDevice.toLowerCase();

    setState(() {
      _selectedDevice = choice;
      _hasChecked = true;
      if (isCorrect) _score++;
    });

    if (isCorrect) {
      audio.playSfx(SfxType.correct);
      final today = DateTime.now();
      final todayKey =
          '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      ref.read(statsDaoProvider).recordDailyActivity(
            dayKey: todayKey,
            xp: 25,
            goalMet: true,
          );
    } else {
      audio.playSfx(SfxType.wrong);
    }

    _learnedItems.add(
      LearnedItem(
        term: '${current.targetDevice} (Rhetorical Device)',
        ipa: null,
        definition: current.explanation,
        example: '"${current.excerpt}" — ${current.author}, ${current.work}',
        wasMistake: !isCorrect,
      ),
    );
  }

  void _next() {
    if (_currentIndex + 1 < _items.length) {
      setState(() {
        _currentIndex++;
        _selectedDevice = null;
        _hasChecked = false;
      });
    } else {
      // Finished all items
      final accuracy = _items.isNotEmpty ? _score / _items.length : 1.0;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WhatYouLearnedScreen(
            gameTitle: 'Style & Rhetoric Analyzer',
            items: _learnedItems,
            score: _score,
            xpEarned: _score * 25,
            accuracy: accuracy,
            onPlayAgain: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const StyleAnalyzerScreen()),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0C10),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_items.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0C10),
        appBar: AppBar(title: const Text('Style Analyzer')),
        body: const Center(child: Text('No rhetorical passages loaded.', style: TextStyle(color: Colors.white70))),
      );
    }

    final current = _items[_currentIndex];
    final audio = ref.read(audioServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        title: const Text(
          'Style & Rhetoric Analyzer',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        backgroundColor: const Color(0xFF12161F),
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${_currentIndex + 1}/${_items.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF818CF8)),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Meta Header Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF141824),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.auto_stories, color: Color(0xFF818CF8), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            current.author,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            current.work,
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'C2 RHETORIC',
                        style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Quotation Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF181C28),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.format_quote, color: Color(0xFF818CF8), size: 30),
                        IconButton(
                          icon: const Icon(Icons.volume_up, color: Color(0xFF818CF8), size: 22),
                          onPressed: () => audio.speakOrPlay(current.excerpt),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"${current.excerpt}"',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Identify the dominant rhetorical device in this excerpt:',
                style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              // Options Grid
              ...current.options.map((option) {
                final isSelected = _selectedDevice == option;
                final isTarget = option.toLowerCase() == current.targetDevice.toLowerCase();

                Color borderColor = Colors.white.withValues(alpha: 0.1);
                Color bgColor = const Color(0xFF141824);
                Color textColor = Colors.white;

                if (_hasChecked) {
                  if (isTarget) {
                    borderColor = const Color(0xFF10B981);
                    bgColor = const Color(0xFF10B981).withValues(alpha: 0.15);
                    textColor = const Color(0xFF34D399);
                  } else if (isSelected && !isTarget) {
                    borderColor = const Color(0xFFEF4444);
                    bgColor = const Color(0xFFEF4444).withValues(alpha: 0.15);
                    textColor = const Color(0xFFF87171);
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: _hasChecked ? null : () => _verifyChoice(option),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: isSelected || (_hasChecked && isTarget) ? 1.5 : 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          if (_hasChecked && isTarget)
                            const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20)
                          else if (_hasChecked && isSelected && !isTarget)
                            const Icon(Icons.cancel, color: Color(0xFFEF4444), size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              // Explanation Card
              if (_hasChecked) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2333),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lightbulb, color: Color(0xFFF59E0B), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'RHETORICAL ANALYSIS',
                            style: TextStyle(
                              color: Color(0xFFF59E0B),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        current.explanation,
                        style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.45),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _currentIndex + 1 < _items.length ? 'Next Rhetorical Passage' : 'Complete Analysis',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
