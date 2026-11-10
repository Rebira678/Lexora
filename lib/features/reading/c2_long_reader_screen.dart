import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../../core/audio/audio_service.dart';
import '../../core/services/phase5_content_service.dart';

class EssayParagraph {
  final String text;
  final String annotation;
  final List<String> c2Vocabulary;

  EssayParagraph({
    required this.text,
    required this.annotation,
    required this.c2Vocabulary,
  });

  factory EssayParagraph.fromJson(Map<String, dynamic> json) {
    return EssayParagraph(
      text: json['text'] as String,
      annotation: json['annotation'] as String,
      c2Vocabulary: List<String>.from(json['c2Vocabulary'] as List),
    );
  }
}

class EssayQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  EssayQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory EssayQuestion.fromJson(Map<String, dynamic> json) {
    return EssayQuestion(
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctIndex: json['correctIndex'] as int,
    );
  }
}

class LongFormEssay {
  final int id;
  final String title;
  final String author;
  final int wordCount;
  final String theme;
  final List<EssayParagraph> paragraphs;
  final List<EssayQuestion> comprehensionQuestions;

  LongFormEssay({
    required this.id,
    required this.title,
    required this.author,
    required this.wordCount,
    required this.theme,
    required this.paragraphs,
    required this.comprehensionQuestions,
  });

  factory LongFormEssay.fromJson(Map<String, dynamic> json) {
    return LongFormEssay(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      wordCount: json['wordCount'] as int,
      theme: json['theme'] as String,
      paragraphs: (json['paragraphs'] as List)
          .map((p) => EssayParagraph.fromJson(p as Map<String, dynamic>))
          .toList(),
      comprehensionQuestions: (json['comprehensionQuestions'] as List)
          .map((q) => EssayQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}

class C2LongReaderScreen extends ConsumerStatefulWidget {
  const C2LongReaderScreen({super.key});

  @override
  ConsumerState<C2LongReaderScreen> createState() => _C2LongReaderScreenState();
}

class _C2LongReaderScreenState extends ConsumerState<C2LongReaderScreen> {
  List<LongFormEssay> _essays = [];
  LongFormEssay? _selectedEssay;
  bool _isLoading = true;
  bool _inQuizMode = false;
  int _currentQuizIndex = 0;
  int? _selectedAnswer;
  int _quizScore = 0;
  bool _quizAnswerChecked = false;
  final Stopwatch _readTimer = Stopwatch();

  @override
  void initState() {
    super.initState();
    _loadEssays();
  }

  Future<void> _loadEssays() async {
    try {
      final data = await Phase5ContentService.instance.loadContent();
      final list = (data['long_form_essays'] as List)
          .map((e) => LongFormEssay.fromJson(e as Map<String, dynamic>))
          .toList();

      if (mounted) {
        setState(() {
          _essays = list;
          if (list.isNotEmpty) {
            _selectedEssay = list.first;
            _readTimer.start();
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _selectEssay(LongFormEssay essay) {
    setState(() {
      _selectedEssay = essay;
      _inQuizMode = false;
      _currentQuizIndex = 0;
      _selectedAnswer = null;
      _quizScore = 0;
      _quizAnswerChecked = false;
      _readTimer.reset();
      _readTimer.start();
    });
  }

  void _checkQuizAnswer(int index) {
    if (_quizAnswerChecked) return;
    final currentQ = _selectedEssay!.comprehensionQuestions[_currentQuizIndex];
    final isCorrect = index == currentQ.correctIndex;
    final audio = ref.read(audioServiceProvider);

    setState(() {
      _selectedAnswer = index;
      _quizAnswerChecked = true;
      if (isCorrect) _quizScore++;
    });

    if (isCorrect) {
      audio.playSfx(SfxType.correct);
      final today = DateTime.now();
      final todayKey =
          '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      ref.read(statsDaoProvider).recordDailyActivity(
            dayKey: todayKey,
            xp: 30,
            goalMet: true,
          );
    } else {
      audio.playSfx(SfxType.wrong);
    }
  }

  void _nextQuizQuestion() {
    final questions = _selectedEssay!.comprehensionQuestions;
    if (_currentQuizIndex + 1 < questions.length) {
      setState(() {
        _currentQuizIndex++;
        _selectedAnswer = null;
        _quizAnswerChecked = false;
      });
    } else {
      // Quiz finished
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF131722),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.workspace_premium, color: Color(0xFFF59E0B), size: 28),
              SizedBox(width: 8),
              Text('Essay Comprehension Complete', style: TextStyle(color: Colors.white, fontSize: 17)),
            ],
          ),
          content: Text(
            'You scored $_quizScore / ${questions.length} on the critical reading synthesis for "${_selectedEssay!.title}".\n\n+50 XP awarded for classical scholarship!',
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _inQuizMode = false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
              child: const Text('Back to Reading'),
            ),
          ],
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

    final audio = ref.read(audioServiceProvider);
    final essay = _selectedEssay;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        title: const Text('Great Works & Essays (C2)', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF12161F),
        elevation: 0,
        actions: [
          PopupMenuButton<LongFormEssay>(
            icon: const Icon(Icons.library_books),
            tooltip: 'Select Essay',
            onSelected: _selectEssay,
            itemBuilder: (ctx) => _essays
                .map((e) => PopupMenuItem(
                      value: e,
                      child: Text('${e.title} (${e.author})'),
                    ))
                .toList(),
          ),
        ],
      ),
      body: essay == null
          ? const Center(child: Text('No essays available.', style: TextStyle(color: Colors.white70)))
          : _inQuizMode
              ? _buildQuizView(essay)
              : _buildReaderView(essay, audio),
    );
  }

  Widget _buildReaderView(LongFormEssay essay, AudioService audio) {
    final elapsedSecs = _readTimer.elapsed.inSeconds;
    final wpm = elapsedSecs > 10 ? ((essay.wordCount / elapsedSecs) * 60).round() : 0;

    return Column(
      children: [
        // Essay Header Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: const BoxDecoration(
            color: Color(0xFF141824),
            border: Border(bottom: BorderSide(color: Colors.white10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      essay.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${essay.author} • ${essay.wordCount} words',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (wpm > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '$wpm WPM',
                    style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
        // Reading Body
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              ...essay.paragraphs.asMap().entries.map((entry) {
                final idx = entry.key;
                final p = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Paragraph Number Pill
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '¶ ${idx + 1}',
                              style: const TextStyle(color: Color(0xFF818CF8), fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.volume_up, size: 18, color: Color(0xFF818CF8)),
                            onPressed: () => audio.speakOrPlay(p.text),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Main Text
                      Text(
                        p.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.6,
                          letterSpacing: 0.1,
                          fontFamily: 'serif',
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Stylistic Margin Annotation
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2333),
                          borderRadius: BorderRadius.circular(10),
                          border: Border(left: BorderSide(color: const Color(0xFFF59E0B), width: 3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.auto_awesome, color: Color(0xFFF59E0B), size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                p.annotation,
                                style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // C2 Lexical Badges
                      if (p.c2Vocabulary.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: p.c2Vocabulary.map((v) {
                            return ActionChip(
                              avatar: const Icon(Icons.search, size: 14, color: Color(0xFF38BDF8)),
                              label: Text(v),
                              onPressed: () => audio.speakOrPlay(v),
                              backgroundColor: const Color(0xFF141824),
                              labelStyle: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12),
                              side: BorderSide(color: const Color(0xFF0284C7).withValues(alpha: 0.3)),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              // Complete Reading & Take Synthesis Quiz Button
              ElevatedButton.icon(
                onPressed: () {
                  _readTimer.stop();
                  setState(() => _inQuizMode = true);
                },
                icon: const Icon(Icons.quiz_outlined),
                label: const Text('Complete Reading & Take Synthesis Quiz'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuizView(LongFormEssay essay) {
    final questions = essay.comprehensionQuestions;
    final currentQ = questions[_currentQuizIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Comprehension & Inference Check',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Text(
                'Question ${_currentQuizIndex + 1} / ${questions.length}',
                style: const TextStyle(color: Color(0xFF818CF8), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF181C28),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Text(
              currentQ.question,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, height: 1.4),
            ),
          ),
          const SizedBox(height: 20),
          ...currentQ.options.asMap().entries.map((entry) {
            final idx = entry.key;
            final opt = entry.value;
            final isTarget = idx == currentQ.correctIndex;
            final isSelected = _selectedAnswer == idx;

            Color borderColor = Colors.white.withValues(alpha: 0.1);
            Color bgColor = const Color(0xFF141824);
            Color textColor = Colors.white;

            if (_quizAnswerChecked) {
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
                onTap: _quizAnswerChecked ? null : () => _checkQuizAnswer(idx),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: textColor.withValues(alpha: 0.4)),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + idx),
                            style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          opt,
                          style: TextStyle(color: textColor, fontSize: 14, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          if (_quizAnswerChecked)
            ElevatedButton(
              onPressed: _nextQuizQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                _currentQuizIndex + 1 < questions.length ? 'Next Question' : 'Finish Synthesis',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
        ],
      ),
    );
  }
}
