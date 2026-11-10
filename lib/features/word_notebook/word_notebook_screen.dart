import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../../core/audio/audio_service.dart';
import '../../core/db/database.dart';

enum WordMasteryStage {
  all('All'),
  fresh('New'),
  learning('Learning'),
  reviewing('Reviewing'),
  familiar('Familiar'),
  mastered('Mastered'),
  retired('Retired');

  final String label;
  const WordMasteryStage(this.label);
}

class WordItemModel {
  final Word word;
  final SrsCard? srsCard;
  final WordMasteryStage stage;

  WordItemModel({
    required this.word,
    required this.srsCard,
    required this.stage,
  });
}

class WordNotebookScreen extends ConsumerStatefulWidget {
  const WordNotebookScreen({super.key});

  @override
  ConsumerState<WordNotebookScreen> createState() => _WordNotebookScreenState();
}

class _WordNotebookScreenState extends ConsumerState<WordNotebookScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCefr = 'All';
  WordMasteryStage _selectedStage = WordMasteryStage.all;

  List<WordItemModel> _allWords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadWords() async {
    setState(() => _isLoading = true);
    final wordDao = ref.read(wordDaoProvider);
    final db = ref.read(databaseProvider);
    final words = await wordDao.getAllWords();
    final allCards = await (db.select(db.srsCards)..where((c) => c.itemType.equals('word'))).get();
    final Map<int, SrsCard> cardMap = {for (var c in allCards) c.itemId: c};

    final items = words.map((w) {
      final card = cardMap[w.id];
      final stage = _calculateStage(card);
      return WordItemModel(word: w, srsCard: card, stage: stage);
    }).toList();

    if (mounted) {
      setState(() {
        _allWords = items;
        _isLoading = false;
      });
    }
  }

  WordMasteryStage _calculateStage(SrsCard? card) {
    if (card == null) return WordMasteryStage.fresh;
    if (card.intervalDays >= 180) return WordMasteryStage.retired;
    if (card.intervalDays >= 30 || card.repetitions >= 10) return WordMasteryStage.mastered;
    if (card.intervalDays >= 14 || card.repetitions >= 6) return WordMasteryStage.familiar;
    if (card.intervalDays >= 3 || card.repetitions >= 3) return WordMasteryStage.reviewing;
    if (card.repetitions > 0) return WordMasteryStage.learning;
    return WordMasteryStage.fresh;
  }

  Color _getStageColor(WordMasteryStage stage) {
    switch (stage) {
      case WordMasteryStage.fresh:
        return Colors.blueGrey;
      case WordMasteryStage.learning:
        return const Color(0xFFF59E0B); // Amber
      case WordMasteryStage.reviewing:
        return const Color(0xFF3B82F6); // Blue
      case WordMasteryStage.familiar:
        return const Color(0xFF8B5CF6); // Purple
      case WordMasteryStage.mastered:
        return const Color(0xFF10B981); // Emerald Green
      case WordMasteryStage.retired:
        return const Color(0xFF06B6D4); // Cyan
      case WordMasteryStage.all:
        return Colors.white70;
    }
  }

  List<WordItemModel> get _filteredWords {
    return _allWords.where((item) {
      // CEFR Filter
      if (_selectedCefr != 'All' && item.word.cefr?.toUpperCase() != _selectedCefr) {
        return false;
      }
      // Mastery Filter
      if (_selectedStage != WordMasteryStage.all && item.stage != _selectedStage) {
        return false;
      }
      // Search Filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesLemma = item.word.lemma.toLowerCase().contains(query);
        final matchesDef = item.word.definitionEn?.toLowerCase().contains(query) ?? false;
        final matchesTag = item.word.tags?.toLowerCase().contains(query) ?? false;
        return matchesLemma || matchesDef || matchesTag;
      }
      return true;
    }).toList();
  }

  void _showWordDetails(WordItemModel item) async {
    final wordDao = ref.read(wordDaoProvider);
    final audio = ref.read(audioServiceProvider);

    final examples = await wordDao.getExamplesForWord(item.word.id);
    final collocations = await wordDao.getCollocationsForWord(item.word.id);

    if (!mounted) return;

    final mnemonicController = TextEditingController(text: item.word.userMnemonic ?? '');
    final sentenceController = TextEditingController(text: item.word.userSentence ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF131722),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              maxChildSize: 0.95,
              minChildSize: 0.5,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    left: 20,
                    right: 20,
                    top: 12,
                  ),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Top Row: Lemma & Audio & CEFR
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item.word.lemma,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    if (item.word.cefr != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: const Color(0xFF6366F1), width: 1),
                                        ),
                                        child: Text(
                                          item.word.cefr!.toUpperCase(),
                                          style: const TextStyle(
                                            color: Color(0xFF818CF8),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                if (item.word.ipa != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    item.word.ipa!,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 15,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton.filled(
                            onPressed: () => audio.speakOrPlay(item.word.lemma),
                            icon: const Icon(Icons.volume_up, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Mastery Stage & POS
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(
                            avatar: Icon(Icons.circle, size: 12, color: _getStageColor(item.stage)),
                            label: Text(
                              'Stage: ${item.stage.label}',
                              style: TextStyle(color: _getStageColor(item.stage), fontWeight: FontWeight.w600),
                            ),
                            backgroundColor: _getStageColor(item.stage).withValues(alpha: 0.12),
                            side: BorderSide(color: _getStageColor(item.stage).withValues(alpha: 0.3)),
                          ),
                          if (item.word.pos != null)
                            Chip(
                              label: Text(
                                item.word.pos!,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              backgroundColor: Colors.white10,
                              side: BorderSide.none,
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // English Definition Card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2333),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DEFINITION',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.word.definitionEn ?? 'No definition available.',
                              style: const TextStyle(fontSize: 15, color: Colors.white, height: 1.4),
                            ),
                            if (item.word.nuanceNote != null) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '💡 Nuance: ${item.word.nuanceNote!}',
                                  style: const TextStyle(fontSize: 13, color: Color(0xFFC7D2FE)),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Examples
                      if (examples.isNotEmpty) ...[
                        const Text(
                          'EXAMPLES',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...examples.map((ex) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF181C28),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      ex.sentence,
                                      style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.volume_up, size: 20, color: Color(0xFF818CF8)),
                                    onPressed: () => audio.speakOrPlay(ex.sentence),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 16),
                      ],
                      // Collocations
                      if (collocations.isNotEmpty) ...[
                        const Text(
                          'COMMON COLLOCATIONS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: collocations
                              .map((c) => ActionChip(
                                    label: Text(c.phrase),
                                    onPressed: () => audio.speakOrPlay(c.phrase),
                                    backgroundColor: const Color(0xFF1E2333),
                                    labelStyle: const TextStyle(color: Color(0xFF38BDF8), fontSize: 13),
                                    side: const BorderSide(color: Color(0xFF0284C7), width: 0.8),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                      // Personal Mnemonics Section ("My Memory Trick" - Spec 6.5)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2333),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.psychology, size: 18, color: Color(0xFFF59E0B)),
                                SizedBox(width: 8),
                                Text(
                                  'MY MEMORY TRICK (MNEMONIC)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                    color: Color(0xFFF59E0B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: mnemonicController,
                              maxLines: 2,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'e.g. Sounds like..., Rhymes with..., Imagining a picture of...',
                                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 13),
                                filled: true,
                                fillColor: const Color(0xFF131722),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await wordDao.updateUserMnemonic(item.word.id, mnemonicController.text.trim());
                                  if (ctx.mounted) {
                                    ScaffoldMessenger.of(ctx).showSnackBar(
                                      const SnackBar(
                                        content: Text('Memory trick saved to your offline notebook!'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                    _loadWords();
                                  }
                                },
                                icon: const Icon(Icons.save, size: 16),
                                label: const Text('Save Trick'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF59E0B),
                                  foregroundColor: Colors.black,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Personal Life Sentence Section ("Example from My Life" - Spec 6.5)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2333),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.edit_note, size: 18, color: Color(0xFF10B981)),
                                SizedBox(width: 8),
                                Text(
                                  'EXAMPLE FROM MY LIFE',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: sentenceController,
                              maxLines: 2,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Write a sentence about your actual work, friends, or hobby...',
                                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 13),
                                filled: true,
                                fillColor: const Color(0xFF131722),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await wordDao.updateUserSentence(item.word.id, sentenceController.text.trim());
                                  if (ctx.mounted) {
                                    ScaffoldMessenger.of(ctx).showSnackBar(
                                      const SnackBar(
                                        content: Text('Personal example saved!'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                    _loadWords();
                                  }
                                },
                                icon: const Icon(Icons.check, size: 16),
                                label: const Text('Save Life Example'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981),
                                  foregroundColor: Colors.black,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // "I Already Know This" Button (Spec 6.5 & 7.4)
                      OutlinedButton.icon(
                        onPressed: () async {
                          await wordDao.markWordAsKnownOrRetired(item.word.id);
                          audio.playSfx(SfxType.levelUp);
                          if (ctx.mounted) {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(
                                content: Text('"${item.word.lemma}" archived as Mastered / Retired!'),
                                backgroundColor: const Color(0xFF10B981),
                              ),
                            );
                            _loadWords();
                          }
                        },
                        icon: const Icon(Icons.verified, color: Color(0xFF34D399)),
                        label: const Text(
                          'I Already Know This (Retire Word)',
                          style: TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF10B981), width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredWords;

    // Counts for Pokédex status header
    final totalCount = _allWords.length;
    final masteredCount = _allWords.where((w) => w.stage == WordMasteryStage.mastered || w.stage == WordMasteryStage.retired).length;
    final inProgressCount = _allWords.where((w) => w.stage == WordMasteryStage.learning || w.stage == WordMasteryStage.reviewing || w.stage == WordMasteryStage.familiar).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        title: const Text(
          'Word Notebook',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        backgroundColor: const Color(0xFF12161F),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Pokédex Progress Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF12161F),
                    border: Border(bottom: BorderSide(color: Colors.white10)),
                  ),
                  child: Row(
                    children: [
                      _buildStatBadge('Catalog', '$totalCount', Colors.white70),
                      const SizedBox(width: 8),
                      _buildStatBadge('In Progress', '$inProgressCount', const Color(0xFFF59E0B)),
                      const SizedBox(width: 8),
                      _buildStatBadge('Mastered', '$masteredCount', const Color(0xFF10B981)),
                    ],
                  ),
                ),
                // Search Field
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search words, definitions, tags...',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF6366F1)),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.white54),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFF181C28),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF6366F1)),
                      ),
                    ),
                  ),
                ),
                // CEFR Filter Chips
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: ['All', 'A1', 'A2', 'B1', 'B2', 'C1', 'C2'].map((lvl) {
                      final isSelected = _selectedCefr == lvl;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(lvl),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _selectedCefr = lvl),
                          selectedColor: const Color(0xFF6366F1),
                          backgroundColor: const Color(0xFF181C28),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          visualDensity: VisualDensity.compact,
                          side: BorderSide(
                            color: isSelected ? const Color(0xFF818CF8) : Colors.white12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 6),
                // Mastery Stage Filter Chips
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: WordMasteryStage.values.map((stage) {
                      final isSelected = _selectedStage == stage;
                      final stageColor = _getStageColor(stage);
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(stage.label),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _selectedStage = stage),
                          selectedColor: stageColor.withValues(alpha: 0.25),
                          backgroundColor: const Color(0xFF181C28),
                          labelStyle: TextStyle(
                            color: isSelected ? stageColor : Colors.white60,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          visualDensity: VisualDensity.compact,
                          side: BorderSide(
                            color: isSelected ? stageColor : Colors.white12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                // Word List
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.menu_book, size: 56, color: Colors.white.withValues(alpha: 0.2)),
                              const SizedBox(height: 12),
                              Text(
                                'No matching words found',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (ctx, i) {
                            final item = filtered[i];
                            final stageColor = _getStageColor(item.stage);

                            return InkWell(
                              onTap: () => _showWordDetails(item),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF141824),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                                ),
                                child: Row(
                                  children: [
                                    // CEFR indicator bar
                                    Container(
                                      width: 4,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: stageColor,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Lemma & Definition
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                item.word.lemma,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              if (item.word.cefr != null)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Text(
                                                    item.word.cefr!.toUpperCase(),
                                                    style: const TextStyle(
                                                      color: Color(0xFF818CF8),
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item.word.definitionEn ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Stage Pill
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: stageColor.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: stageColor.withValues(alpha: 0.3), width: 0.8),
                                      ),
                                      child: Text(
                                        item.stage.label,
                                        style: TextStyle(
                                          color: stageColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Tap to pronounce
                                    IconButton(
                                      icon: const Icon(Icons.volume_up, size: 20, color: Color(0xFF6366F1)),
                                      onPressed: () => ref.read(audioServiceProvider).speakOrPlay(item.word.lemma),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatBadge(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF181C28),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
