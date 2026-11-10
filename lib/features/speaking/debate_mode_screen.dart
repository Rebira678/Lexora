import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/database.dart';
import '../../core/services/phase4_content_service.dart';
import '../../app/providers.dart';

class DebateModeScreen extends ConsumerStatefulWidget {
  const DebateModeScreen({super.key});

  @override
  ConsumerState<DebateModeScreen> createState() => _DebateModeScreenState();
}

class _DebateModeScreenState extends ConsumerState<DebateModeScreen> {
  List<Map<String, dynamic>> _debates = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  String _selectedStance = 'For'; // 'For' or 'Against'

  // Recording State
  bool _isRecording = false;
  int _secondsRemaining = 90;
  Timer? _debateTimer;

  // Rubric Self-Score (1-5)
  int _rubricRhetoric = 4;
  int _rubricLexis = 4;
  int _rubricRebuttal = 4;
  int _rubricFluency = 4;
  bool _isEvaluated = false;

  @override
  void initState() {
    super.initState();
    _loadDebates();
  }

  @override
  void dispose() {
    _debateTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadDebates() async {
    final data = await Phase4ContentService.instance.loadContent();
    final list = (data['debate_mode'] as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
        [];

    if (!mounted) return;
    setState(() {
      _debates = list;
      _isLoading = false;
    });
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _secondsRemaining = 90;
    });

    _debateTimer?.cancel();
    _debateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 1) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        _stopRecording();
      }
    });
  }

  void _stopRecording() {
    _debateTimer?.cancel();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _saveDebateSession() async {
    final debate = _debates[_currentIndex];
    final db = ref.read(databaseProvider);
    final overallScore = ((_rubricRhetoric + _rubricLexis + _rubricRebuttal + _rubricFluency) / 4.0);

    // Save into recordings table
    await db.into(db.recordings).insert(
          RecordingsCompanion(
            prompt: drift.Value('Debate: ${debate['motion']} ($_selectedStance)'),
            filePath: drift.Value('debate_${DateTime.now().millisecondsSinceEpoch}.m4a'),
            durationMs: drift.Value((90 - _secondsRemaining) * 1000),
            score: drift.Value(overallScore),
            createdAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );

    // Award XP
    await ref.read(statsDaoProvider).recordDailyActivity(
          dayKey: DateTime.now().toIso8601String().substring(0, 10),
          minutes: 3,
          xp: 45,
          itemsReviewed: 1,
          goalMet: true,
        );

    if (!mounted) return;
    setState(() => _isEvaluated = true);
  }

  void _next() {
    if (_currentIndex + 1 < _debates.length) {
      setState(() {
        _currentIndex++;
        _selectedStance = 'For';
        _isRecording = false;
        _secondsRemaining = 90;
        _isEvaluated = false;
      });
    } else {
      Navigator.pop(context);
    }
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

    if (_debates.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0C10),
        appBar: AppBar(title: const Text('Debate Mode')),
        body: const Center(
          child: Text('No debate motions available.', style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    final debate = _debates[_currentIndex];
    final scaffoldPoints = _selectedStance == 'For'
        ? (debate['scaffoldPointsFor'] as List<dynamic>?)?.cast<String>() ?? []
        : (debate['scaffoldPointsAgainst'] as List<dynamic>?)?.cast<String>() ?? [];
    final targetVocab = (debate['targetVocabulary'] as List<dynamic>?)?.cast<String>() ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12161F),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Debate Mode: 90s Argumentation',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'Motion ${_currentIndex + 1} of ${_debates.length} • Parliamentary Style',
              style: const TextStyle(fontSize: 11, color: Color(0xFF818CF8)),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Motion Card
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
                          'PARLIAMENTARY MOTION',
                          style: TextStyle(
                            color: Color(0xFF818CF8),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.gavel_rounded, color: Color(0xFF6366F1), size: 18),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    debate['motion'] as String? ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    debate['background'] as String? ?? '',
                    style: const TextStyle(color: Colors.white60, fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stance Selector
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _isRecording ? null : () => setState(() => _selectedStance = 'For'),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedStance == 'For'
                            ? const Color(0xFF10B981).withAlpha(30)
                            : const Color(0xFF12161F),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedStance == 'For' ? const Color(0xFF10B981) : Colors.white12,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'PROPOSITION (FOR)',
                          style: TextStyle(
                            color: _selectedStance == 'For' ? const Color(0xFF10B981) : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _isRecording ? null : () => setState(() => _selectedStance = 'Against'),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedStance == 'Against'
                            ? const Color(0xFFEF4444).withAlpha(30)
                            : const Color(0xFF12161F),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedStance == 'Against' ? const Color(0xFFEF4444) : Colors.white12,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'OPPOSITION (AGAINST)',
                          style: TextStyle(
                            color: _selectedStance == 'Against' ? const Color(0xFFEF4444) : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Scaffold Arguments
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF12161F),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Key Argumentation Scaffolds:',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  for (var pt in scaffoldPoints)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(pt, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3)),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: targetVocab.map((v) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(10),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(v, style: const TextStyle(color: Color(0xFF818CF8), fontSize: 11)),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 90s Speech Timer & Audio Control
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF161B26),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isRecording ? Colors.redAccent : Colors.white12,
                  width: _isRecording ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '$_secondsRemaining s',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _isRecording ? Colors.redAccent : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isRecording ? 'Delivering speech (speak clearly into mic)...' : 'Press start to begin your 90s speech',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_isRecording)
                        ElevatedButton.icon(
                          onPressed: _startRecording,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.mic, color: Colors.white),
                          label: const Text('Start 90s Speech', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: _stopRecording,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.stop, color: Colors.white),
                          label: const Text('Finish Speech', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // CEFR Debate Self-Evaluation Rubric
            if (!_isRecording && _secondsRemaining < 90 && !_isEvaluated) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF12161F),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF10B981)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CEFR C1 Debate Rubric (Self-Evaluation):',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    _buildRubricSlider('Rhetorical Cohesion', _rubricRhetoric, (v) => setState(() => _rubricRhetoric = v)),
                    _buildRubricSlider('Lexical Precision', _rubricLexis, (v) => setState(() => _rubricLexis = v)),
                    _buildRubricSlider('Counter-Argument Rebuttal', _rubricRebuttal, (v) => setState(() => _rubricRebuttal = v)),
                    _buildRubricSlider('Fluency & Discourse Pace', _rubricFluency, (v) => setState(() => _rubricFluency = v)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _saveDebateSession,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Save Speech Assessment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (_isEvaluated) ...[
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    _currentIndex + 1 < _debates.length ? 'Next Debate Motion' : 'Complete Debate Session',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRubricSlider(String label, int value, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12))),
          Row(
            children: List.generate(5, (index) {
              final star = index + 1;
              return InkWell(
                onTap: () => onChanged(star),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    star <= value ? Icons.star_rounded : Icons.star_border_rounded,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
