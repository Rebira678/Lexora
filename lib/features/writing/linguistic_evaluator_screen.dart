import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../app/providers.dart';
import '../../core/audio/audio_service.dart';
import '../../core/db/database.dart';

class FormalityIssue {
  final String informalWord;
  final String suggestion;
  final String explanation;

  FormalityIssue({
    required this.informalWord,
    required this.suggestion,
    required this.explanation,
  });
}

class LinguisticAnalysisResult {
  final int wordCount;
  final int sentenceCount;
  final double meanSentenceLength;
  final double lexicalSophisticationPercent;
  final int subordinationMarkerCount;
  final List<FormalityIssue> formalityIssues;
  final String estimatedCefr;
  final String teacherFeedback;

  LinguisticAnalysisResult({
    required this.wordCount,
    required this.sentenceCount,
    required this.meanSentenceLength,
    required this.lexicalSophisticationPercent,
    required this.subordinationMarkerCount,
    required this.formalityIssues,
    required this.estimatedCefr,
    required this.teacherFeedback,
  });
}

class LinguisticEvaluatorScreen extends ConsumerStatefulWidget {
  const LinguisticEvaluatorScreen({super.key});

  @override
  ConsumerState<LinguisticEvaluatorScreen> createState() => _LinguisticEvaluatorScreenState();
}

class _LinguisticEvaluatorScreenState extends ConsumerState<LinguisticEvaluatorScreen> {
  final TextEditingController _textController = TextEditingController();
  LinguisticAnalysisResult? _result;
  bool _isAnalyzing = false;

  // High-frequency informal words dictionary with C1/C2 Latinate replacements
  static final Map<String, List<String>> _informalDictionary = {
    'a lot of': ['substantial', 'numerous', 'an abundance of', 'considerable'],
    'gonna': ['intend to', 'plan to', 'shall', 'is projected to'],
    'wanna': ['wish to', 'aspire to', 'seek to'],
    'kids': ['children', 'youth', 'adolescents', 'young citizens'],
    'stuff': ['elements', 'components', 'materials', 'paraphernalia'],
    'huge': ['monumental', 'colossal', 'immense', 'substantial'],
    'big time': ['substantially', 'markedly', 'profoundly'],
    'totally': ['entirely', 'unequivocally', 'wholly'],
    'crazy': ['erratic', 'unprecedented', 'anomalous'],
    'get': ['acquire', 'obtain', 'derive', 'procure'],
    'bad': ['deleterious', 'detrimental', 'adverse', 'pernicious'],
    'good': ['beneficial', 'advantageous', 'salutary', 'propitious'],
    'show': ['demonstrate', 'illustrate', 'substantiate', 'exemplify'],
    'look at': ['examine', 'interrogate', 'scrutinize', 'appraise'],
    'make': ['fabricate', 'synthesize', 'generate', 'formulate'],
    'give': ['provide', 'allocate', 'furnish', 'confer'],
  };

  // Subordination & academic linking markers
  static final Set<String> _subordinationMarkers = {
    'although', 'whereas', 'insofar as', 'nonetheless', 'consequently',
    'furthermore', 'notwithstanding', 'provided that', 'in light of',
    'subsequently', 'whereby', 'inasmuch as', 'thereby', 'while', 'because'
  };

  // C1/C2 Academic lemmas
  static final Set<String> _c1c2AcademicLexicon = {
    'paradigm', 'empirical', 'substantiate', 'disparity', 'inherent',
    'catalyze', 'equivocal', 'tangential', 'culmination', 'dichotomy',
    'ephemeral', 'ubiquitous', 'panacea', 'pernicious', 'esoteric',
    'anachronistic', 'meticulous', 'fastidious', 'disinterested',
    'frugal', 'ambivalent', 'ingenious', 'adverse', 'discrete',
    'venal', 'exacerbate', 'pragmatic', 'complacent', 'triangulation',
    'heuristic', 'mitigate', 'unprecedented', 'plausible', 'comprehensive'
  };

  void _analyzeText() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isAnalyzing = true);

    final words = text.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final sentences = text.split(RegExp(r'[.!?]+')).where((s) => s.trim().isNotEmpty).toList();

    final wordCount = words.length;
    final sentenceCount = sentences.isEmpty ? 1 : sentences.length;
    final meanSentenceLength = wordCount / sentenceCount;

    // Detect C1/C2 academic density
    int academicMatches = 0;
    for (final w in words) {
      final clean = w.replaceAll(RegExp(r'[^a-zA-Z]'), '');
      if (_c1c2AcademicLexicon.contains(clean)) {
        academicMatches++;
      }
    }
    final sophisticationPercent = wordCount > 0 ? (academicMatches / wordCount) * 100.0 : 0.0;

    // Subordination markers
    int subordinationCount = 0;
    final lowerText = text.toLowerCase();
    for (final marker in _subordinationMarkers) {
      if (lowerText.contains(marker)) {
        subordinationCount++;
      }
    }

    // Formality audit
    final issues = <FormalityIssue>[];
    for (final entry in _informalDictionary.entries) {
      final phrase = entry.key;
      if (lowerText.contains(phrase)) {
        issues.add(
          FormalityIssue(
            informalWord: phrase,
            suggestion: entry.value.join(', '),
            explanation: "Colloquial usage. In formal academic discourse, substitute with '${entry.value.first}'.",
          ),
        );
      }
    }

    // CEFR band estimation logic
    String cefr = 'B1';
    String teacherFeedback = '';

    if (meanSentenceLength >= 22 && sophisticationPercent >= 4.0 && subordinationCount >= 3 && issues.isEmpty) {
      cefr = 'C2 Mastery';
      teacherFeedback =
          'Exemplary scholarship! Demonstrates syntactic subordination, robust Latinate vocabulary, and spotless academic register.';
    } else if (meanSentenceLength >= 16 && (sophisticationPercent >= 2.0 || subordinationCount >= 2) && issues.length <= 1) {
      cefr = 'C1 Advanced';
      teacherFeedback =
          'Sophisticated academic style. Strong clause cohesion and advanced vocabulary with minimal colloquial intrusion.';
    } else if (meanSentenceLength >= 12) {
      cefr = 'B2 Independent';
      teacherFeedback =
          'Solid communicative coherence, but sentences rely on coordinated compound syntax rather than complex hypotactic subordination.';
    } else {
      cefr = 'B1 Threshold';
      teacherFeedback =
          'Clauses are relatively short and elementary. Introduce academic linking words and eliminate colloquial expressions.';
    }

    ref.read(audioServiceProvider).playSfx(SfxType.levelUp);

    setState(() {
      _result = LinguisticAnalysisResult(
        wordCount: wordCount,
        sentenceCount: sentenceCount,
        meanSentenceLength: meanSentenceLength,
        lexicalSophisticationPercent: sophisticationPercent,
        subordinationMarkerCount: subordinationCount,
        formalityIssues: issues,
        estimatedCefr: cefr,
        teacherFeedback: teacherFeedback,
      );
      _isAnalyzing = false;
    });
  }

  Future<void> _saveToPortfolio() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final db = ref.read(databaseProvider);
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.into(db.userTexts).insert(
          UserTextsCompanion.insert(
            prompt: 'C2 Linguistic Evaluation Essay',
            body: text,
            createdAt: now,
            selfScore: drift.Value(_result?.estimatedCefr.startsWith('C') == true ? 5 : 4),
          ),
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Essay archived to your offline Writing Portfolio!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  void _loadSampleC2() {
    _textController.text =
        'Although empirical observations substantiate the initial hypothesis, persistent disparities across secondary test cohorts precipitated grave reservations among reviewing clinicians. Consequently, researchers must calibrate algorithmic parameters while simultaneously eliminating anachronistic sampling biases.';
    _analyzeText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        title: const Text('Linguistic & Rubric Engine', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF12161F),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _loadSampleC2,
            child: const Text('Sample C2', style: TextStyle(color: Color(0xFF818CF8))),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Info
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF141824),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.analytics_outlined, color: Color(0xFF6366F1), size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'On-device syntactic complexity, academic vocabulary density, and register audit engine.',
                        style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Text Area
              TextField(
                controller: _textController,
                maxLines: 6,
                style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
                decoration: InputDecoration(
                  hintText: 'Type or paste an essay paragraph to analyze for C1/C2 maturity...',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                  filled: true,
                  fillColor: const Color(0xFF181C28),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.white12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.white12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF6366F1)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isAnalyzing ? null : _analyzeText,
                      icon: const Icon(Icons.speed),
                      label: const Text('Evaluate Syntax & Style'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: _saveToPortfolio,
                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: const Text('Save'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF10B981),
                      side: const BorderSide(color: Color(0xFF10B981)),
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Results Display
              if (_result != null) ...[
                // CEFR Predicted Tier Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2333),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _result!.estimatedCefr.startsWith('C') ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'PREDICTED CEFR BAND',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1, color: Colors.white54),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _result!.estimatedCefr.startsWith('C')
                                  ? const Color(0xFF10B981).withValues(alpha: 0.2)
                                  : const Color(0xFFF59E0B).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _result!.estimatedCefr,
                              style: TextStyle(
                                color: _result!.estimatedCefr.startsWith('C') ? const Color(0xFF34D399) : const Color(0xFFF59E0B),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _result!.teacherFeedback,
                        style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Metric Stats Grid
                Row(
                  children: [
                    _buildStatCard('Mean Sentence Length', '${_result!.meanSentenceLength.toStringAsFixed(1)} words', 'Target: 18-25'),
                    const SizedBox(width: 8),
                    _buildStatCard('Lexical Sophistication', '${_result!.lexicalSophisticationPercent.toStringAsFixed(1)}%', 'C1/C2 density'),
                    const SizedBox(width: 8),
                    _buildStatCard('Subordination', '${_result!.subordinationMarkerCount} clauses', 'Complex links'),
                  ],
                ),
                const SizedBox(height: 16),
                // Formality Audit Issues
                if (_result!.formalityIssues.isNotEmpty) ...[
                  const Text(
                    'REGISTER & FORMALITY SUGGESTIONS',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Color(0xFFF87171)),
                  ),
                  const SizedBox(height: 8),
                  ..._result!.formalityIssues.map((issue) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF181C28),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFEF4444)),
                                const SizedBox(width: 8),
                                Text(
                                  '"${issue.informalWord}"',
                                  style: const TextStyle(color: Color(0xFFF87171), fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, size: 14, color: Colors.white54),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    issue.suggestion,
                                    style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold, fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(issue.explanation, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                          ],
                        ),
                      )),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String sub) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF141824),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11)),
            const SizedBox(height: 4),
            Text(sub, style: const TextStyle(color: Color(0xFF818CF8), fontSize: 10, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
