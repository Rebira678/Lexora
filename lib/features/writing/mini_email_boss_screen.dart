import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/database.dart';
import '../../core/services/phase3_content_service.dart';
import '../../app/providers.dart';

class MiniEmailBossScreen extends ConsumerStatefulWidget {
  const MiniEmailBossScreen({super.key});

  @override
  ConsumerState<MiniEmailBossScreen> createState() => _MiniEmailBossScreenState();
}

class _MiniEmailBossScreenState extends ConsumerState<MiniEmailBossScreen> {
  final TextEditingController _textController = TextEditingController();
  List<Map<String, dynamic>> _scenarios = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isSubmitted = false;
  int _selfScore = 5;

  @override
  void initState() {
    super.initState();
    _loadScenarios();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadScenarios() async {
    final data = await Phase3ContentService.instance.loadContent();
    final list = (data['email_boss'] as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
        [];

    if (!mounted) return;
    setState(() {
      _scenarios = list;
      _isLoading = false;
    });
  }

  int get _wordCount {
    final text = _textController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
  }

  bool _phraseIncluded(String phrase) {
    return _textController.text
        .toLowerCase()
        .contains(phrase.trim().toLowerCase());
  }

  Future<void> _submitEmail() async {
    final scenario = _scenarios[_currentIndex];
    final title = 'Email Boss: ${scenario['scenario']}';
    final content = _textController.text.trim();

    if (content.isEmpty) return;

    final db = ref.read(databaseProvider);
    await db.into(db.userTexts).insert(
          UserTextsCompanion(
            prompt: drift.Value(title),
            body: drift.Value(content),
            createdAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
            selfScore: drift.Value(_selfScore),
          ),
        );

    if (!mounted) return;
    setState(() {
      _isSubmitted = true;
    });
  }

  void _nextScenario() {
    if (_currentIndex + 1 < _scenarios.length) {
      setState(() {
        _currentIndex++;
        _textController.clear();
        _isSubmitted = false;
        _selfScore = 5;
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

    if (_scenarios.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0C10),
        appBar: AppBar(
          backgroundColor: const Color(0xFF12161F),
          title: const Text('Mini Email Boss'),
        ),
        body: const Center(
          child: Text('No email scenarios available.',
              style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    final scenario = _scenarios[_currentIndex];
    final requiredPhrases =
        (scenario['requiredPhrases'] as List<dynamic>?)?.cast<String>() ?? [];
    final minWords = scenario['minWords'] as int? ?? 40;
    final allPhrasesIncluded =
        requiredPhrases.every((p) => _phraseIncluded(p));
    final wordCountMet = _wordCount >= minWords;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12161F),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mini Email Boss',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'Scenario ${_currentIndex + 1} of ${_scenarios.length} • Professional Register',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6366F1),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prompt Card
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
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'C1 DIPLOMATIC REGISTER',
                          style: TextStyle(
                            color: Color(0xFF818CF8),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Min words: $minWords',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    scenario['scenario'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'To: ${scenario['recipient']}',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    scenario['instructions'] as String,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Required Phrases Checklist
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF12161F),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: allPhrasesIncluded
                      ? const Color(0xFF10B981).withValues(alpha: 0.5)
                      : Colors.white12,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        allPhrasesIncluded
                            ? Icons.check_circle
                            : Icons.checklist_rtl_rounded,
                        color: allPhrasesIncluded
                            ? const Color(0xFF10B981)
                            : const Color(0xFF6366F1),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Mandatory C1 Collocations & Formulas:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: requiredPhrases.map((phrase) {
                      final included = _phraseIncluded(phrase);
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: included
                              ? const Color(0xFF10B981).withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.05),
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
                              size: 14,
                              color: included
                                  ? const Color(0xFF10B981)
                                  : Colors.white38,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              phrase,
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
                  border: Border.all(
                    color: wordCountMet
                        ? const Color(0xFF6366F1)
                        : Colors.white24,
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _textController,
                      maxLines: 8,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Compose your professional email here...\ne.g. Dear Dr. Harrison,\n\nI hope this email finds you well...',
                        hintStyle: TextStyle(color: Colors.white30, fontSize: 13),
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
                          Icon(
                            wordCountMet
                                ? Icons.check
                                : Icons.text_snippet_outlined,
                            size: 16,
                            color: wordCountMet
                                ? const Color(0xFF10B981)
                                : Colors.white38,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Words: $_wordCount / $minWords',
                            style: TextStyle(
                              color: wordCountMet
                                  ? const Color(0xFF10B981)
                                  : Colors.white54,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${requiredPhrases.where((p) => _phraseIncluded(p)).length}/${requiredPhrases.length} formulas used',
                            style: TextStyle(
                              color: allPhrasesIncluded
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

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: (_wordCount >= 10) ? _submitEmail : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    disabledBackgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                  label: const Text(
                    'Submit to Boss Review',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Comparison with Senior Model Email
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
                    Row(
                      children: [
                        const Icon(
                          Icons.workspace_premium_rounded,
                          color: Color(0xFF10B981),
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Submission Analysis & Senior Model',
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
                      'Your Draft:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _textController.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Senior Executive Model Email:',
                      style: TextStyle(
                        color: Color(0xFF818CF8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        scenario['modelEmail'] as String? ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Self-Evaluation (Pedagogical Reflection):',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (index) {
                        final star = index + 1;
                        return IconButton(
                          icon: Icon(
                            star <= _selfScore ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              _selfScore = star;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _nextScenario,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _currentIndex + 1 < _scenarios.length
                              ? 'Next Email Scenario'
                              : 'Complete Boss Battle',
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
