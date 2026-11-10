import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/db/database.dart';
import '../../core/services/phase4_content_service.dart';
import '../../app/providers.dart';

class RealEnglishLogScreen extends ConsumerStatefulWidget {
  const RealEnglishLogScreen({super.key});

  @override
  ConsumerState<RealEnglishLogScreen> createState() => _RealEnglishLogScreenState();
}

class _RealEnglishLogScreenState extends ConsumerState<RealEnglishLogScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FlutterTts _tts = FlutterTts();

  List<WildItem> _wildItems = [];
  List<Map<String, dynamic>> _contentPacks = [];
  bool _isLoading = true;

  // New Wild Item Form
  final _lemmaController = TextEditingController();
  final _sentenceController = TextEditingController();
  final _sourceController = TextEditingController(text: 'The Economist / Podcast');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initTts();
    _loadData();
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.48);
    } catch (_) {}
  }

  @override
  void dispose() {
    _tabController.dispose();
    _lemmaController.dispose();
    _sentenceController.dispose();
    _sourceController.dispose();
    _tts.stop();
    super.dispose();
  }

  Future<void> _loadData() async {
    final db = ref.read(databaseProvider);
    final wildList = await (db.select(db.wildItems)
          ..orderBy([(w) => drift.OrderingTerm.desc(w.savedAt)]))
        .get();

    final data = await Phase4ContentService.instance.loadContent();
    final packs = (data['c1_content_packs'] as List<dynamic>?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
        [];

    if (!mounted) return;
    setState(() {
      _wildItems = wildList;
      _contentPacks = packs;
      _isLoading = false;
    });
  }

  void _showAddWildItemDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF12161F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.bookmark_add_rounded, color: Color(0xFF6366F1), size: 22),
            SizedBox(width: 8),
            Text('Log Wild Vocabulary', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _lemmaController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Word / Phrase (e.g. paradigm shift)',
                  labelStyle: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _sentenceController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Context Sentence where you encountered it',
                  labelStyle: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _sourceController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Source (Podcast, Journal, Lecture)',
                  labelStyle: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _saveWildItem();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
            child: const Text('Save to SRS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveWildItem() async {
    final lemma = _lemmaController.text.trim();
    final sentence = _sentenceController.text.trim();
    final source = _sourceController.text.trim();

    if (lemma.isEmpty || sentence.isEmpty) return;

    final db = ref.read(databaseProvider);

    // 1. Insert into Words
    final wordId = await db.into(db.words).insert(
          WordsCompanion(
            lemma: drift.Value(lemma),
            pos: const drift.Value('wild'),
            cefr: const drift.Value('C1'),
            definitionEn: drift.Value('Captured from: $source'),
            source: const drift.Value('wild'),
            userSentence: drift.Value(sentence),
          ),
        );

    // 2. Insert into WildItems
    await db.into(db.wildItems).insert(
          WildItemsCompanion(
            wordId: drift.Value(wordId),
            sentence: drift.Value(sentence),
            source: drift.Value(source),
            savedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );

    // 3. Insert into SrsCards
    await db.into(db.srsCards).insert(
          SrsCardsCompanion(
            itemType: const drift.Value('word'),
            itemId: drift.Value(wordId),
            skill: const drift.Value('vocab'),
            ease: const drift.Value(2.5),
            intervalDays: const drift.Value(0),
            repetitions: const drift.Value(0),
            lapses: const drift.Value(0),
            dueAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );

    _lemmaController.clear();
    _sentenceController.clear();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "$lemma" from the wild to your SRS deck!'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );

    _loadData();
  }

  Future<void> _installContentPack(Map<String, dynamic> pack) async {
    final words = (pack['words'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
    final db = ref.read(databaseProvider);

    int added = 0;
    await db.transaction(() async {
      for (var w in words) {
        final wordId = await db.into(db.words).insert(
              WordsCompanion(
                lemma: drift.Value(w['lemma'] as String),
                pos: drift.Value(w['pos'] as String? ?? 'noun'),
                cefr: drift.Value(w['cefr'] as String? ?? 'C1'),
                definitionEn: drift.Value(w['definition'] as String? ?? ''),
                source: drift.Value('pack_${pack['packId']}'),
                userSentence: drift.Value(w['example'] as String? ?? ''),
              ),
            );

        await db.into(db.srsCards).insert(
              SrsCardsCompanion(
                itemType: const drift.Value('word'),
                itemId: drift.Value(wordId),
                skill: const drift.Value('vocab'),
                ease: const drift.Value(2.5),
                intervalDays: const drift.Value(0),
                repetitions: const drift.Value(0),
                lapses: const drift.Value(0),
                dueAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
              ),
            );
        added++;
      }
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Installed ${pack['title']} ($added words added to SRS)!'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0C10),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF6366F1))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12161F),
        elevation: 0,
        title: const Text(
          'Real English Log & C1 Packs',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF6366F1),
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: [
            Tab(icon: const Icon(Icons.travel_explore_rounded, size: 18), text: 'Wild Capture (${_wildItems.length})'),
            Tab(icon: const Icon(Icons.layers_rounded, size: 18), text: 'C1 Content Packs (${_contentPacks.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWildCaptureTab(),
          _buildPacksTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddWildItemDialog,
        backgroundColor: const Color(0xFF6366F1),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Capture Wild Word', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildWildCaptureTab() {
    if (_wildItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_book_rounded, size: 64, color: Colors.white.withAlpha(40)),
              const SizedBox(height: 16),
              const Text(
                'No Wild Captures Yet',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'When reading articles or listening to podcasts, log unfamiliar C1 words along with their exact sentence to anchor authentic context in SRS.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _showAddWildItemDialog,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Log First Encounter', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _wildItems.length,
      itemBuilder: (context, index) {
        final item = _wildItems[index];
        return Card(
          color: const Color(0xFF12161F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white12),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withAlpha(30),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.source ?? 'Wild Encounter',
                        style: const TextStyle(color: Color(0xFF818CF8), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF6366F1), size: 20),
                      onPressed: () => _tts.speak(item.sentence),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '"${item.sentence}"',
                  style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPacksTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _contentPacks.length,
      itemBuilder: (context, index) {
        final pack = _contentPacks[index];
        final words = (pack['words'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];

        return Card(
          color: const Color(0xFF12161F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Colors.white12),
          ),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.auto_stories_rounded, color: Color(0xFF10B981), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pack['title'] as String? ?? '',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${words.length} High-Yield C1 Units',
                            style: const TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  pack['description'] as String? ?? '',
                  style: const TextStyle(color: Colors.white60, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 14),

                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: words.take(4).map((w) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(10),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        w['lemma'] as String? ?? '',
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () => _installContentPack(pack),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
                    label: const Text('Install Pack into SRS Rotation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
