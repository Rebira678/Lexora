import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/db/database.dart';
import '../../app/providers.dart';

class CustomDeckScreen extends ConsumerStatefulWidget {
  const CustomDeckScreen({super.key});

  @override
  ConsumerState<CustomDeckScreen> createState() => _CustomDeckScreenState();
}

class _CustomDeckScreenState extends ConsumerState<CustomDeckScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FlutterTts _tts = FlutterTts();

  // Single word form controllers
  final _wordController = TextEditingController();
  final _posController = TextEditingController(text: 'noun');
  final _defController = TextEditingController();
  final _exampleController = TextEditingController();
  final _tagController = TextEditingController(text: 'custom');
  String _selectedCefr = 'B2';

  // Batch CSV controller
  final _csvController = TextEditingController();
  List<Map<String, String>> _parsedCsvPreview = [];

  List<Word> _customWords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initTts();
    _loadCustomWords();
    _csvController.addListener(_parseCsv);
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
    _wordController.dispose();
    _posController.dispose();
    _defController.dispose();
    _exampleController.dispose();
    _tagController.dispose();
    _csvController.removeListener(_parseCsv);
    _csvController.dispose();
    _tts.stop();
    super.dispose();
  }

  Future<void> _loadCustomWords() async {
    final db = ref.read(databaseProvider);
    final words = await (db.select(db.words)
          ..where((w) => w.source.equals('custom'))
          ..orderBy([(w) => drift.OrderingTerm.desc(w.id)]))
        .get();

    if (!mounted) return;
    setState(() {
      _customWords = words;
      _isLoading = false;
    });
  }

  void _parseCsv() {
    final text = _csvController.text.trim();
    if (text.isEmpty) {
      setState(() => _parsedCsvPreview = []);
      return;
    }

    final lines = text.split('\n');
    final List<Map<String, String>> preview = [];

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

      final parts = trimmed.split(RegExp(r'[,;|\t]')).map((p) => p.trim()).toList();
      if (parts.isNotEmpty && parts[0].isNotEmpty) {
        preview.add({
          'word': parts[0],
          'definition': parts.length > 1 ? parts[1] : 'Custom vocabulary definition',
          'example': parts.length > 2 ? parts[2] : '',
          'cefr': parts.length > 3 && parts[3].isNotEmpty ? parts[3].toUpperCase() : 'B2',
        });
      }
    }

    setState(() {
      _parsedCsvPreview = preview;
    });
  }

  Future<void> _saveSingleWord() async {
    final word = _wordController.text.trim();
    final def = _defController.text.trim();
    final example = _exampleController.text.trim();
    final pos = _posController.text.trim();
    final tag = _tagController.text.trim();

    if (word.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a word or phrase.')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    final wordId = await db.into(db.words).insert(
          WordsCompanion(
            lemma: drift.Value(word),
            pos: drift.Value(pos.isEmpty ? 'noun' : pos),
            cefr: drift.Value(_selectedCefr),
            definitionEn: drift.Value(def.isEmpty ? 'User custom vocabulary' : def),
            tags: drift.Value(tag.isEmpty ? 'custom' : tag),
            source: const drift.Value('custom'),
            userSentence: drift.Value(example),
          ),
        );

    if (example.isNotEmpty) {
      await db.into(db.examples).insert(
            ExamplesCompanion(
              wordId: drift.Value(wordId),
              sentence: drift.Value(example),
            ),
          );
    }

    // Insert SRS Card so it enters the spaced repetition engine
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

    _wordController.clear();
    _defController.clear();
    _exampleController.clear();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "$word" to your SRS deck!'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );

    _loadCustomWords();
    _tabController.animateTo(0);
  }

  Future<void> _importCsvBatch() async {
    if (_parsedCsvPreview.isEmpty) return;

    final db = ref.read(databaseProvider);
    int addedCount = 0;

    await db.transaction(() async {
      for (final item in _parsedCsvPreview) {
        final wordId = await db.into(db.words).insert(
              WordsCompanion(
                lemma: drift.Value(item['word']!),
                pos: const drift.Value('custom'),
                cefr: drift.Value(item['cefr'] ?? 'B2'),
                definitionEn: drift.Value(item['definition']!),
                tags: const drift.Value('custom,imported'),
                source: const drift.Value('custom'),
                userSentence: drift.Value(item['example'] ?? ''),
              ),
            );

        if (item['example'] != null && item['example']!.isNotEmpty) {
          await db.into(db.examples).insert(
                ExamplesCompanion(
                  wordId: drift.Value(wordId),
                  sentence: drift.Value(item['example']!),
                ),
              );
        }

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
        addedCount++;
      }
    });

    _csvController.clear();
    setState(() => _parsedCsvPreview = []);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully imported $addedCount cards into SRS!'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );

    _loadCustomWords();
    _tabController.animateTo(0);
  }

  Future<void> _deleteWord(int id) async {
    final db = ref.read(databaseProvider);
    await (db.delete(db.words)..where((w) => w.id.equals(id))).go();
    await (db.delete(db.srsCards)
          ..where((c) => c.itemType.equals('word') & c.itemId.equals(id)))
        .go();
    _loadCustomWords();
  }

  void _loadSampleCsvTemplate() {
    _csvController.text =
        'quintessential, representing the most perfect example, It is the quintessential English village, C1\n'
        'ephemeral, lasting for a very short time, Fashions are ephemeral, C1\n'
        'pragmatic, dealing with things sensibly and realistically, We need a pragmatic solution, B2\n'
        'ubiquitous, present or found everywhere, Smart phones have become ubiquitous, C1\n'
        'exacerbate, make a problem worse, Stress can exacerbate health problems, C1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12161F),
        elevation: 0,
        title: const Text(
          'Custom Decks & CSV Importer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF6366F1),
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: [
            Tab(
              icon: const Icon(Icons.style_rounded, size: 20),
              text: 'Cards (${_customWords.length})',
            ),
            const Tab(
              icon: Icon(Icons.add_circle_outline, size: 20),
              text: 'Add Single',
            ),
            const Tab(
              icon: Icon(Icons.file_upload_outlined, size: 20),
              text: 'CSV Import',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCardsTab(),
          _buildAddSingleTab(),
          _buildCsvImportTab(),
        ],
      ),
    );
  }

  Widget _buildCardsTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF6366F1)),
      );
    }

    if (_customWords.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_stories_outlined,
                size: 64,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 16),
              const Text(
                'No Custom Decks Yet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add words individually or import a batch via CSV to build your personalized study deck.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _tabController.animateTo(1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Add First Custom Word',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _customWords.length,
      itemBuilder: (context, index) {
        final word = _customWords[index];
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
                    Text(
                      word.lemma,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        word.cefr ?? 'B2',
                        style: const TextStyle(
                          color: Color(0xFF818CF8),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded,
                          color: Color(0xFF6366F1), size: 20),
                      onPressed: () => _tts.speak(word.lemma),
                      tooltip: 'Pronounce',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.redAccent, size: 20),
                      onPressed: () => _deleteWord(word.id),
                      tooltip: 'Delete Card',
                    ),
                  ],
                ),
                if (word.definitionEn != null && word.definitionEn!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    word.definitionEn!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
                if (word.userSentence != null && word.userSentence!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '"${word.userSentence!}"',
                      style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddSingleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Flashcard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Add a custom word with definition and example to your SRS rotation.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _wordController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Word / Phrase (e.g. serendipity)'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _posController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Part of Speech (e.g. noun)'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF12161F),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCefr,
                      dropdownColor: const Color(0xFF12161F),
                      style: const TextStyle(color: Colors.white),
                      isExpanded: true,
                      items: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
                          .map((lvl) => DropdownMenuItem(
                                value: lvl,
                                child: Text('CEFR $lvl'),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCefr = val);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _defController,
            maxLines: 2,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Definition in English'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _exampleController,
            maxLines: 2,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Example Sentence (Context is King)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _tagController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Tags (e.g. business, exams, travel)'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _saveSingleWord,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Save Card into SRS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCsvImportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Paste CSV / TSV Data',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: _loadSampleCsvTemplate,
                icon: const Icon(Icons.lightbulb_outline,
                    size: 16, color: Color(0xFF818CF8)),
                label: const Text(
                  'Load Template',
                  style: TextStyle(color: Color(0xFF818CF8), fontSize: 12),
                ),
              ),
            ],
          ),
          const Text(
            'Format per line: Word, Definition, Example Sentence, CEFR',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _csvController,
            maxLines: 7,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              fontSize: 12,
            ),
            decoration: InputDecoration(
              hintText: 'word, definition, example sentence, C1\n...',
              hintStyle: const TextStyle(color: Colors.white24),
              filled: true,
              fillColor: const Color(0xFF12161F),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white24),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_parsedCsvPreview.isNotEmpty) ...[
            Text(
              'Parsed Preview (${_parsedCsvPreview.length} cards detected):',
              style: const TextStyle(
                color: Color(0xFF10B981),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFF12161F),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white12),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: _parsedCsvPreview.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: Colors.white10, height: 1),
                itemBuilder: (context, index) {
                  final item = _parsedCsvPreview[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}. ',
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 12),
                        ),
                        Text(
                          item['word'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item['definition'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF6366F1).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['cefr'] ?? 'B2',
                            style: const TextStyle(
                              color: Color(0xFF818CF8),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _importCsvBatch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.check_circle_outline,
                    color: Colors.white),
                label: Text(
                  'Import ${_parsedCsvPreview.length} Cards Now',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
      filled: true,
      fillColor: const Color(0xFF12161F),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF6366F1)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}
