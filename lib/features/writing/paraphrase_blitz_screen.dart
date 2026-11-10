import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/database.dart';
import '../../core/services/phase4_content_service.dart';
import '../../app/providers.dart';

class ParaphraseBlitzScreen extends ConsumerStatefulWidget {
  const ParaphraseBlitzScreen({super.key});

  @override
  ConsumerState<ParaphraseBlitzScreen> createState() => _ParaphraseBlitzScreenState();
}

class _ParaphraseBlitzScreenState extends ConsumerState<ParaphraseBlitzScreen> {
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  List<Map<String, dynamic>> _exercises = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _loadExercises();
    for (var c in _controllers) {
      c.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.removeListener(_onTextChanged);
      c.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadExercises() async {
    final data = await Phase4ContentService.instance.loadContent();
    final list = (data['paraphrase_blitz'] as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
        [];

    if (!mounted) return;
    setState(() {
      _exercises = list;
      _isLoading = false;
    });
  }

  bool get _canSubmit {
    return _controllers.every((c) => c.text.trim().split(RegExp(r'\s+')).length >= 5);
  }

  Future<void> _submitParaphrases() async {
    final item = _exercises[_currentIndex];
    final db = ref.read(databaseProvider);

    for (int i = 0; i < 3; i++) {
      final text = _controllers[i].text.trim();
      if (text.isNotEmpty) {
        await db.into(db.userTexts).insert(
              UserTextsCompanion(
                prompt: drift.Value('Paraphrase Blitz: ${item['targetPatterns'][i]}'),
                body: drift.Value(text),
                createdAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
                selfScore: const drift.Value(5),
              ),
            );
      }
    }

    await ref.read(statsDaoProvider).recordDailyActivity(
          dayKey: DateTime.now().toIso8601String().substring(0, 10),
          minutes: 4,
          xp: 40,
          itemsReviewed: 3,
          goalMet: true,
        );

    if (!mounted) return;
    setState(() => _isSubmitted = true);
  }

  void _next() {
    if (_currentIndex + 1 < _exercises.length) {
      setState(() {
        _currentIndex++;
        for (var c in _controllers) {
          c.clear();
        }
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
        appBar: AppBar(title: const Text('Paraphrase Blitz')),
        body: const Center(
          child: Text('No paraphrase exercises found.',
              style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    final item = _exercises[_currentIndex];
    final targetPatterns = (item['targetPatterns'] as List<dynamic>?)?.cast<String>() ?? [];
    final modelParaphrases = (item['modelParaphrases'] as List<dynamic>?)?.cast<String>() ?? [];
    final keyCollocations = (item['keyCollocations'] as List<dynamic>?)?.cast<String>() ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12161F),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paraphrase Blitz',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              'Exercise ${_currentIndex + 1} of ${_exercises.length} • Syntactic Dexterity',
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
            // Source Proposition Card
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
                          color: const Color(0xFF6366F1).withAlpha(40),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'SOURCE PROPOSITION',
                          style: TextStyle(
                            color: Color(0xFF818CF8),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.sync_alt_rounded,
                          color: Color(0xFF6366F1), size: 18),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item['sourceIdea'] as String? ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  if (keyCollocations.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: keyCollocations.map((col) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(10),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            col,
                            style: const TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),

            const Text(
              'Rewrite the proposition using 3 distinct C1 syntactic frameworks:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // 3 Scaffolded Transformation Slots
            for (int i = 0; i < targetPatterns.length; i++) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF161B26),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _controllers[i].text.trim().isNotEmpty
                        ? const Color(0xFF6366F1)
                        : Colors.white12,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: const Color(0xFF6366F1),
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            targetPatterns[i],
                            style: const TextStyle(
                              color: Color(0xFF818CF8),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (!_isSubmitted)
                      TextField(
                        controller: _controllers[i],
                        maxLines: 2,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Enter paraphrase ${i + 1}...',
                          hintStyle: const TextStyle(
                              color: Colors.white24, fontSize: 12),
                          filled: true,
                          fillColor: const Color(0xFF10141D),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      )
                    else ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _controllers[i].text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Senior Academic Model: ${modelParaphrases[i]}',
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            // Submit / Next Buttons
            if (!_isSubmitted)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _canSubmit ? _submitParaphrases : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    disabledBackgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.flash_on_rounded, color: Colors.white),
                  label: const Text(
                    'Submit 3 Paraphrases',
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
                        ? 'Next Paraphrase Challenge'
                        : 'Complete Blitz Session',
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
}
