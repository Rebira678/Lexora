import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/database.dart';
import '../../core/services/phase4_content_service.dart';
import '../../app/providers.dart';

class LectureNotesScreen extends ConsumerStatefulWidget {
  const LectureNotesScreen({super.key});

  @override
  ConsumerState<LectureNotesScreen> createState() => _LectureNotesScreenState();
}

class _LectureNotesScreenState extends ConsumerState<LectureNotesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FlutterTts _tts = FlutterTts();

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _synthesisController = TextEditingController();

  List<Map<String, dynamic>> _lectures = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isPlaying = false;
  double _speechRate = 0.50; // authentic default speed

  // Question state
  final Map<int, int?> _selectedAnswers = {};
  bool _hasCheckedQuestions = false;
  int _questionScore = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initTts();
    _loadLectures();
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(_speechRate);
      _tts.setCompletionHandler(() {
        if (mounted) setState(() => _isPlaying = false);
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notesController.dispose();
    _synthesisController.dispose();
    _tts.stop();
    super.dispose();
  }

  Future<void> _loadLectures() async {
    final data = await Phase4ContentService.instance.loadContent();
    final list = (data['lecture_notes'] as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
        [];

    if (!mounted) return;
    setState(() {
      _lectures = list;
      _isLoading = false;
    });
  }

  Future<void> _toggleAudio() async {
    if (_lectures.isEmpty) return;
    final transcript = _lectures[_currentIndex]['transcript'] as String? ?? '';

    if (_isPlaying) {
      await _tts.stop();
      setState(() => _isPlaying = false);
    } else {
      await _tts.setSpeechRate(_speechRate);
      setState(() => _isPlaying = true);
      await _tts.speak(transcript);
    }
  }

  void _changeSpeed(double speed) async {
    setState(() => _speechRate = speed);
    await _tts.setSpeechRate(speed);
    if (_isPlaying) {
      final transcript = _lectures[_currentIndex]['transcript'] as String? ?? '';
      await _tts.stop();
      await _tts.speak(transcript);
    }
  }

  void _verifyQuestions() {
    final lecture = _lectures[_currentIndex];
    final questions =
        (lecture['cornellQuestions'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];

    int correct = 0;
    for (int i = 0; i < questions.length; i++) {
      if (_selectedAnswers[i] == questions[i]['correctIndex']) {
        correct++;
      }
    }

    setState(() {
      _hasCheckedQuestions = true;
      _questionScore = correct;
    });
  }

  Future<void> _saveSynthesis() async {
    final synthesisText = _synthesisController.text.trim();
    if (synthesisText.isEmpty) return;

    final lecture = _lectures[_currentIndex];
    final db = ref.read(databaseProvider);

    await db.into(db.userTexts).insert(
          UserTextsCompanion(
            prompt: drift.Value('Lecture Synthesis: ${lecture['title']}'),
            body: drift.Value(synthesisText),
            createdAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
            selfScore: const drift.Value(5),
          ),
        );

    await ref.read(statsDaoProvider).recordDailyActivity(
          dayKey: DateTime.now().toIso8601String().substring(0, 10),
          minutes: 5,
          xp: 50,
          itemsReviewed: 1,
          goalMet: true,
        );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lecture synthesis saved to your writing portfolio!'),
        backgroundColor: Color(0xFF10B981),
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

    if (_lectures.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0C10),
        appBar: AppBar(title: const Text('Lecture Notes')),
        body: const Center(
          child: Text('No academic lectures loaded.',
              style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    final lecture = _lectures[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12161F),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lecture Notes: Academic Listening',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              lecture['title'] as String? ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Color(0xFF818CF8)),
            ),
          ],
        ),
        actions: [
          if (_lectures.length > 1)
            PopupMenuButton<int>(
              icon: const Icon(Icons.swap_horiz_rounded, color: Colors.white70),
              tooltip: 'Switch Lecture',
              onSelected: (idx) {
                setState(() {
                  _currentIndex = idx;
                  _selectedAnswers.clear();
                  _hasCheckedQuestions = false;
                  _notesController.clear();
                  _synthesisController.clear();
                });
              },
              itemBuilder: (ctx) => List.generate(
                _lectures.length,
                (i) => PopupMenuItem(
                  value: i,
                  child: Text(_lectures[i]['title'] as String? ?? 'Lecture ${i + 1}'),
                ),
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF6366F1),
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(icon: Icon(Icons.headphones_rounded, size: 18), text: 'Lecture & Notes'),
            Tab(icon: Icon(Icons.quiz_rounded, size: 18), text: 'Checkpoints'),
            Tab(icon: Icon(Icons.summarize_rounded, size: 18), text: 'Synthesis'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLectureAndNotesTab(lecture),
          _buildCheckpointsTab(lecture),
          _buildSynthesisTab(lecture),
        ],
      ),
    );
  }

  Widget _buildLectureAndNotesTab(Map<String, dynamic> lecture) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Audio Player Control Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF12161F),
              borderRadius: BorderRadius.circular(14),
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
                      child: const Text(
                        'AUTHENTIC SPEED AUDIO',
                        style: TextStyle(
                          color: Color(0xFF818CF8),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      lecture['duration'] as String? ?? '3 min',
                      style: const TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  lecture['title'] as String? ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lecture['speaker'] as String? ?? '',
                  style: const TextStyle(color: Color(0xFF10B981), fontSize: 12),
                ),
                const SizedBox(height: 16),

                // Audio Play / Pause & Speed Bar
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _toggleAudio,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isPlaying ? Colors.redAccent : const Color(0xFF6366F1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow_rounded, color: Colors.white),
                      label: Text(
                        _isPlaying ? 'Pause' : 'Stream Talk',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    const Text('Speed: ', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    for (var speed in [0.45, 0.50, 0.58]) ...[
                      InkWell(
                        onTap: () => _changeSpeed(speed),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: _speechRate == speed
                                ? const Color(0xFF6366F1)
                                : Colors.white.withAlpha(15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            speed == 0.45 ? '0.8x' : (speed == 0.50 ? '1.0x' : '1.25x'),
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Cornell Notes Pad
          const Text(
            'Cornell Notes Scratchpad:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Record key assertions, supporting empirical data, and technical lexis while listening.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF161B26),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: TextField(
              controller: _notesController,
              maxLines: 10,
              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
              decoration: const InputDecoration(
                hintText: '• System 1: heuristic, automated, evolutionary...\n• System 2: deliberative, normative, slow...\n• Availability heuristic: episodic recall vs. empirical tables...',
                hintStyle: TextStyle(color: Colors.white30, fontSize: 12),
                contentPadding: EdgeInsets.all(14),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckpointsTab(Map<String, dynamic> lecture) {
    final questions =
        (lecture['cornellQuestions'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Comprehension Checkpoints',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (_hasCheckedQuestions)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withAlpha(30),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Score: $_questionScore / ${questions.length}',
                    style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          for (int qIdx = 0; qIdx < questions.length; qIdx++) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF12161F),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q${qIdx + 1}. ${questions[qIdx]['question']}',
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    (questions[qIdx]['options'] as List).length,
                    (optIdx) {
                      final optText = questions[qIdx]['options'][optIdx] as String;
                      final isSelected = _selectedAnswers[qIdx] == optIdx;
                      final isCorrect = optIdx == questions[qIdx]['correctIndex'];

                      Color cardColor = const Color(0xFF161B26);
                      Color borderColor = Colors.white12;

                      if (_hasCheckedQuestions) {
                        if (isCorrect) {
                          cardColor = const Color(0xFF10B981).withAlpha(30);
                          borderColor = const Color(0xFF10B981);
                        } else if (isSelected) {
                          cardColor = const Color(0xFFEF4444).withAlpha(30);
                          borderColor = const Color(0xFFEF4444);
                        }
                      } else if (isSelected) {
                        borderColor = const Color(0xFF6366F1);
                        cardColor = const Color(0xFF6366F1).withAlpha(20);
                      }

                      return InkWell(
                        onTap: _hasCheckedQuestions
                            ? null
                            : () {
                                setState(() {
                                  _selectedAnswers[qIdx] = optIdx;
                                });
                              },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${String.fromCharCode(65 + optIdx)}.',
                                style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(optText, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],

          if (!_hasCheckedQuestions)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _selectedAnswers.length == questions.length ? _verifyQuestions : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Verify Comprehension', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSynthesisTab(Map<String, dynamic> lecture) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF12161F),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF6366F1).withAlpha(80)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.edit_note_rounded, color: Color(0xFF818CF8), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Executive Synthesis Prompt',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  lecture['synthesisPrompt'] as String? ?? '',
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF161B26),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: TextField(
              controller: _synthesisController,
              maxLines: 7,
              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
              decoration: const InputDecoration(
                hintText: 'Synthesize the lecture argument in 3-5 sentences using technical terminology...\ne.g. System 1 operates as a rapid evolutionary heuristic...',
                hintStyle: TextStyle(color: Colors.white30, fontSize: 12),
                contentPadding: EdgeInsets.all(14),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _synthesisController.text.trim().length >= 30 ? _saveSynthesis : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.save_rounded, color: Colors.white),
              label: const Text('Save Synthesis to Portfolio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
