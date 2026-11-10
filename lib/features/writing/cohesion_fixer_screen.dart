import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/audio/audio_service.dart';
import '../../core/db/database.dart';
import '../../core/services/phase4_content_service.dart';
import '../../app/providers.dart';
import '../games/widgets/what_you_learned_screen.dart';

class CohesionFixerScreen extends ConsumerStatefulWidget {
  const CohesionFixerScreen({super.key});

  @override
  ConsumerState<CohesionFixerScreen> createState() => _CohesionFixerScreenState();
}

class _CohesionFixerScreenState extends ConsumerState<CohesionFixerScreen> {
  List<Map<String, dynamic>> _exercises = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  // Selected connectors for gaps (gapIndex -> connectorString)
  Map<int, String?> _assignedConnectors = {};
  List<String> _connectorPool = [];
  bool _hasChecked = false;
  bool _isAllCorrect = false;

  int _score = 0;
  int _xpEarned = 0;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final data = await Phase4ContentService.instance.loadContent();
    final list = (data['cohesion_fixer'] as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
        [];

    if (!mounted) return;
    setState(() {
      _exercises = list;
      _isLoading = false;
    });

    _initCurrentExercise();
  }

  void _initCurrentExercise() {
    if (_exercises.isEmpty) return;
    final item = _exercises[_currentIndex];
    final connectors = (item['missingConnectors'] as List<dynamic>?)
            ?.map((c) => c['connector'] as String)
            .toList() ??
        [];

    setState(() {
      _assignedConnectors = {};
      _connectorPool = List<String>.from(connectors)..shuffle();
      _hasChecked = false;
      _isAllCorrect = false;
    });
  }

  void _assignConnector(int gapIndex, String connector) {
    if (_hasChecked) return;
    setState(() {
      _assignedConnectors[gapIndex] = connector;
    });
  }

  void _clearGap(int gapIndex) {
    if (_hasChecked) return;
    setState(() {
      _assignedConnectors.remove(gapIndex);
    });
  }

  void _verifyCohesion() {
    final item = _exercises[_currentIndex];
    final missingList = (item['missingConnectors'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
        [];

    bool allCorrect = true;
    for (var m in missingList) {
      final gapIdx = m['gapIndex'] as int;
      final expected = (m['connector'] as String).trim().toLowerCase();
      final actual = (_assignedConnectors[gapIdx] ?? '').trim().toLowerCase();
      if (actual != expected) {
        allCorrect = false;
      }
    }

    setState(() {
      _hasChecked = true;
      _isAllCorrect = allCorrect;
    });

    if (allCorrect) {
      _score += 150;
      _xpEarned += 25;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
    }

    _learnedItems.add(
      LearnedItem(
        term: 'Cohesion Exercise ${_currentIndex + 1}',
        definition: 'Discourse Ties',
        example: item['explanation'] as String? ?? '',
        wasMistake: !allCorrect,
      ),
    );
  }

  void _next() {
    if (_currentIndex + 1 < _exercises.length) {
      setState(() {
        _currentIndex++;
      });
      _initCurrentExercise();
    } else {
      _finishSession();
    }
  }

  Future<void> _finishSession() async {
    final durationMs = DateTime.now().millisecondsSinceEpoch - _roundStartTime;
    final total = _exercises.isNotEmpty ? _exercises.length : 1;

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'cohesion_fixer',
            mode: const drift.Value('discourse_ties'),
            level: const drift.Value(4),
            startedAt: _roundStartTime,
            durationMs: durationMs,
            accuracy: _score > 0 ? 1.0 : 0.5,
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
          gameTitle: '🔗 Cohesion Fixer (Discourse Ties)',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: _isAllCorrect ? 1.0 : 0.8,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const CohesionFixerScreen()),
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

    if (_exercises.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0C10),
        appBar: AppBar(title: const Text('Cohesion Fixer')),
        body: const Center(
          child: Text('No cohesion exercises available.',
              style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    final item = _exercises[_currentIndex];
    final missingList = (item['missingConnectors'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
        [];
    final allFilled = missingList.every((m) => _assignedConnectors.containsKey(m['gapIndex']));

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12161F),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cohesion Fixer: Discourse Flow',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              'Exercise ${_currentIndex + 1} of ${_exercises.length} • Discourse Markers',
              style: const TextStyle(fontSize: 12, color: Color(0xFF818CF8)),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Faulty Text Analysis Card
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.amber.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'CHOPPY DISJOINTED PASSAGE',
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.link_off_rounded,
                          color: Colors.amber, size: 18),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item['faultyText'] as String? ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Gap Assignment Area
            const Text(
              'Assign transitional connectors into the designated structural slots:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            for (var m in missingList) ...[
              _buildSlotTile(m),
            ],
            const SizedBox(height: 16),

            // Connector Bank
            const Text(
              'Available C1 Discourse Markers:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _connectorPool.map((connector) {
                final isAssigned = _assignedConnectors.containsValue(connector);
                return InkWell(
                  onTap: isAssigned || _hasChecked
                      ? null
                      : () {
                          // Find first unassigned gap
                          for (var m in missingList) {
                            final gIdx = m['gapIndex'] as int;
                            if (!_assignedConnectors.containsKey(gIdx)) {
                              _assignConnector(gIdx, connector);
                              break;
                            }
                          }
                        },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isAssigned
                          ? Colors.white10
                          : const Color(0xFF6366F1).withAlpha(40),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isAssigned
                            ? Colors.white24
                            : const Color(0xFF6366F1),
                      ),
                    ),
                    child: Text(
                      connector,
                      style: TextStyle(
                        color: isAssigned ? Colors.white38 : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Verification & Feedback
            if (_hasChecked) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isAllCorrect
                      ? const Color(0xFF10B981).withAlpha(20)
                      : const Color(0xFFEF4444).withAlpha(20),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _isAllCorrect
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isAllCorrect
                              ? Icons.verified_rounded
                              : Icons.warning_amber_rounded,
                          color: _isAllCorrect
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isAllCorrect
                              ? 'Cohesive Flow Achieved!'
                              : 'Cohesion Alignment Analysis',
                          style: TextStyle(
                            color: _isAllCorrect
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Target Integrated Passage:',
                      style: TextStyle(
                        color: Color(0xFF818CF8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['repairedText'] as String? ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['explanation'] as String? ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            if (!_hasChecked)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: allFilled ? _verifyCohesion : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    disabledBackgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.link_rounded, color: Colors.white),
                  label: const Text(
                    'Verify Cohesion Flow',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentIndex + 1 < _exercises.length
                        ? 'Next Cohesion Exercise'
                        : 'Complete Session',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotTile(Map<String, dynamic> m) {
    final gapIdx = m['gapIndex'] as int;
    final role = m['role'] as String;
    final expected = m['connector'] as String;
    final assigned = _assignedConnectors[gapIdx];

    final isCorrect = _hasChecked &&
        assigned != null &&
        assigned.trim().toLowerCase() == expected.trim().toLowerCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF161B26),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _hasChecked
              ? (isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444))
              : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withAlpha(30),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'SLOT $gapIdx: $role',
              style: const TextStyle(
                color: Color(0xFF818CF8),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              assigned ?? 'Tap a connector from below',
              style: TextStyle(
                color: assigned != null ? Colors.white : Colors.white30,
                fontWeight:
                    assigned != null ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
          if (assigned != null && !_hasChecked)
            IconButton(
              icon: const Icon(Icons.close, size: 16, color: Colors.white38),
              onPressed: () => _clearGap(gapIdx),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
