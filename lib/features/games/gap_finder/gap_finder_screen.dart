import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/providers.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../core/services/phase5_content_service.dart';

class GapWordItem {
  final int id;
  final String lemma;
  final String cefr;
  final String? ipa;
  final String? pos;
  final String definition;
  final String sentence;

  GapWordItem({
    required this.id,
    required this.lemma,
    required this.cefr,
    this.ipa,
    this.pos,
    required this.definition,
    required this.sentence,
  });

  factory GapWordItem.fromJson(Map<String, dynamic> json) {
    return GapWordItem(
      id: json['id'] as int,
      lemma: json['lemma'] as String,
      cefr: json['cefr'] as String,
      ipa: json['ipa'] as String?,
      pos: json['pos'] as String?,
      definition: json['definition'] as String,
      sentence: json['sentence'] as String,
    );
  }
}

class GapFinderScreen extends ConsumerStatefulWidget {
  const GapFinderScreen({super.key});

  @override
  ConsumerState<GapFinderScreen> createState() => _GapFinderScreenState();
}

class _GapFinderScreenState extends ConsumerState<GapFinderScreen> {
  List<GapWordItem> _words = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  final List<GapWordItem> _knownWords = [];
  final List<GapWordItem> _gapWords = [];

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    try {
      final data = await Phase5ContentService.instance.loadContent();
      final list = (data['gap_finder_words'] as List)
          .map((w) => GapWordItem.fromJson(w as Map<String, dynamic>))
          .toList();

      if (mounted) {
        setState(() {
          _words = list..shuffle();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _markKnown() async {
    final current = _words[_currentIndex];
    final audio = ref.read(audioServiceProvider);
    audio.playSfx(SfxType.correct);

    _knownWords.add(current);
    _advance();
  }

  Future<void> _markGap() async {
    final current = _words[_currentIndex];
    final audio = ref.read(audioServiceProvider);
    final db = ref.read(databaseProvider);
    audio.playSfx(SfxType.wrong);

    _gapWords.add(current);

    // Insert or prioritize in SRS cards
    final now = DateTime.now().millisecondsSinceEpoch;
    try {
      final existingCard = await (db.select(db.srsCards)
            ..where((c) => c.itemType.equals('word') & c.itemId.equals(current.id)))
          .getSingleOrNull();

      if (existingCard != null) {
        await (db.update(db.srsCards)..where((c) => c.id.equals(existingCard.id))).write(
          SrsCardsCompanion(
            dueAt: drift.Value(now),
            intervalDays: const drift.Value(0),
            repetitions: const drift.Value(0),
          ),
        );
      } else {
        await db.into(db.srsCards).insert(
              SrsCardsCompanion.insert(
                itemType: 'word',
                itemId: current.id,
                skill: 'vocab',
                ease: const drift.Value(2.5),
                intervalDays: const drift.Value(0),
                repetitions: const drift.Value(0),
                dueAt: now,
              ),
            );
      }
    } catch (_) {}

    _advance();
  }

  void _advance() {
    if (_currentIndex + 1 < _words.length) {
      setState(() => _currentIndex++);
    } else {
      _showResults();
    }
  }

  void _showResults() {
    final today = DateTime.now();
    final todayKey =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    ref.read(statsDaoProvider).recordDailyActivity(
          dayKey: todayKey,
          xp: 40,
          goalMet: true,
        );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF131722),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
        ),
        title: const Row(
          children: [
            Icon(Icons.radar, color: Color(0xFF6366F1), size: 28),
            SizedBox(width: 10),
            Text('Gap Diagnostic Complete', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diagnostic scanned ${_words.length} advanced academic & C2 words.',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        Text('${_knownWords.length}', style: const TextStyle(color: Color(0xFF34D399), fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        const Text('Known Words', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        Text('${_gapWords.length}', style: const TextStyle(color: Color(0xFFF87171), fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        const Text('Queued into SRS', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Identified gap words were immediately scheduled for spaced repetition review in your daily mission queue.',
              style: TextStyle(color: Colors.white60, fontSize: 12, height: 1.4),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Return to Arena'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0C10),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_words.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0C10),
        appBar: AppBar(title: const Text('Gap Finder')),
        body: const Center(child: Text('No diagnostic words available.', style: TextStyle(color: Colors.white70))),
      );
    }

    final current = _words[_currentIndex];
    final audio = ref.read(audioServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        title: const Text('Lexical Gap Finder', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF12161F),
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${_currentIndex + 1}/${_words.length}',
                style: const TextStyle(color: Color(0xFF818CF8), fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / _words.length,
                  minHeight: 6,
                  backgroundColor: Colors.white10,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                ),
              ),
              const SizedBox(height: 24),
              // Word Diagnostic Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF181C28),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // CEFR Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF6366F1), width: 1),
                        ),
                        child: Text(
                          '${current.cefr} TIER',
                          style: const TextStyle(color: Color(0xFF818CF8), fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Lemma
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            current.lemma,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.volume_up, color: Color(0xFF818CF8)),
                            onPressed: () => audio.speakOrPlay(current.lemma),
                          ),
                        ],
                      ),
                      if (current.ipa != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          current.ipa!,
                          style: TextStyle(color: Colors.grey[400], fontSize: 16, fontFamily: 'monospace'),
                        ),
                      ],
                      const SizedBox(height: 20),
                      // Definition
                      Text(
                        current.definition,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.4),
                      ),
                      const SizedBox(height: 24),
                      // Carrier Sentence
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131722),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                        ),
                        child: Text(
                          '"${current.sentence}"',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Decision Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _markGap,
                      icon: const Icon(Icons.close, color: Color(0xFFF87171)),
                      label: const Text(
                        "Don't Know",
                        style: TextStyle(color: Color(0xFFF87171), fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
                        minimumSize: const Size(0, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _markKnown,
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text(
                        'I Know This',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        minimumSize: const Size(0, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
