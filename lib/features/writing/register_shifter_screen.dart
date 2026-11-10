import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/database.dart';
import '../../core/services/phase4_content_service.dart';
import '../../app/providers.dart';

class RegisterShifterScreen extends ConsumerStatefulWidget {
  const RegisterShifterScreen({super.key});

  @override
  ConsumerState<RegisterShifterScreen> createState() => _RegisterShifterScreenState();
}

class _RegisterShifterScreenState extends ConsumerState<RegisterShifterScreen> {
  final TextEditingController _textController = TextEditingController();
  List<Map<String, dynamic>> _exercises = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _loadExercises();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadExercises() async {
    final data = await Phase4ContentService.instance.loadContent();
    final list = (data['register_shifter'] as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
        [];

    if (!mounted) return;
    setState(() {
      _exercises = list;
      _isLoading = false;
    });
  }

  bool _markerIncluded(String marker) {
    return _textController.text
        .toLowerCase()
        .contains(marker.trim().toLowerCase());
  }

  int get _wordCount {
    final text = _textController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
  }

  Future<void> _submitTransformation() async {
    final item = _exercises[_currentIndex];
    final title = 'Register Shifter: ${item['targetRegister']}';
    final content = _textController.text.trim();

    if (content.isEmpty) return;

    final db = ref.read(databaseProvider);
    await db.into(db.userTexts).insert(
          UserTextsCompanion(
            prompt: drift.Value(title),
            body: drift.Value(content),
            createdAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
            selfScore: const drift.Value(5),
          ),
        );

    // Record XP
    await ref.read(statsDaoProvider).recordDailyActivity(
          dayKey: DateTime.now().toIso8601String().substring(0, 10),
          minutes: 3,
          xp: 30,
          itemsReviewed: 1,
          goalMet: true,
        );

    if (!mounted) return;
    setState(() => _isSubmitted = true);
  }

  void _next() {
    if (_currentIndex + 1 < _exercises.length) {
      setState(() {
        _currentIndex++;
        _textController.clear();
        _isSubmitted = false;
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

    if (_exercises.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0C10),
        appBar: AppBar(title: const Text('Register Shifter')),
        body: const Center(
          child: Text('No register shift exercises found.',
              style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    final item = _exercises[_currentIndex];
    final requiredMarkers =
        (item['requiredMarkers'] as List<dynamic>?)?.cast<String>() ?? [];
    final allMarkersUsed =
        requiredMarkers.every((m) => _markerIncluded(m));

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12161F),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Register Shifter',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              'Exercise ${_currentIndex + 1} of ${_exercises.length} • Sociolinguistic Style',
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
            // Casual Source Card
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
                          color: const Color(0xFFEF4444).withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'ORIGINAL CASUAL MESSAGE',
                          style: TextStyle(
                            color: Color(0xFFF87171),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        item['context'] as String? ?? '',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '"${item['casualPrompt']}"',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.arrow_forward_rounded,
                          size: 16, color: Color(0xFF6366F1)),
                      const SizedBox(width: 6),
                      Text(
                        'Target Style: ${item['targetRegister']}',
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Required Markers Checklist
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF12161F),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: allMarkersUsed
                      ? const Color(0xFF10B981).withAlpha(100)
                      : Colors.white12,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mandatory C1 Formal Markers & Hedging:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: requiredMarkers.map((marker) {
                      final included = _markerIncluded(marker);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: included
                              ? const Color(0xFF10B981).withAlpha(30)
                              : Colors.white.withAlpha(15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: included
                                ? const Color(0xFF10B981)
                                : Colors.white24,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              included
                                  ? Icons.check_circle_rounded
                                  : Icons.circle_outlined,
                              size: 13,
                              color: included
                                  ? const Color(0xFF10B981)
                                  : Colors.white38,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              marker,
                              style: TextStyle(
                                color: included ? Colors.white : Colors.white70,
                                fontSize: 12,
                                fontWeight: included
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (!_isSubmitted) ...[
              // Editor
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF161B26),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _textController,
                      maxLines: 6,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      decoration: const InputDecoration(
                        hintText:
                            'Rewrite in formal diplomatic/academic style...\ne.g. Please accept our apologies for the delay...',
                        hintStyle:
                            TextStyle(color: Colors.white30, fontSize: 13),
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF10141D),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(11),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Words: $_wordCount',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${requiredMarkers.where((m) => _markerIncluded(m)).length}/${requiredMarkers.length} markers included',
                            style: TextStyle(
                              color: allMarkersUsed
                                  ? const Color(0xFF10B981)
                                  : Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _wordCount >= 10 ? _submitTransformation : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    disabledBackgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.transform_rounded, color: Colors.white),
                  label: const Text(
                    'Submit Register Shift',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Model & Senior Teacher Breakdown
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
                    const Row(
                      children: [
                        Icon(Icons.school_rounded,
                            color: Color(0xFF10B981), size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Executive Model & Stylistic Analysis',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Senior Executive Model Rewrite:',
                      style: TextStyle(
                        color: Color(0xFF818CF8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['modelTransform'] as String? ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Senior Pedagogical Analysis:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['teacherAnalysis'] as String? ?? '',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _currentIndex + 1 < _exercises.length
                              ? 'Next Register Shift'
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
            ],
          ],
        ),
      ),
    );
  }
}
