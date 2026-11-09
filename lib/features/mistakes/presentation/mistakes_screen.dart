import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../app/providers.dart';
import '../../../core/db/database.dart';
import '../../games/word_siege/word_siege_screen.dart';

class MistakesScreen extends ConsumerStatefulWidget {
  const MistakesScreen({super.key});

  @override
  ConsumerState<MistakesScreen> createState() => _MistakesScreenState();
}

class _MistakesScreenState extends ConsumerState<MistakesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _deleteWildItem(int id) async {
    final db = ref.read(databaseProvider);
    await (db.delete(db.wildItems)..where((t) => t.id.equals(id))).go();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final audio = ref.watch(audioServiceProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Words & Mistakes'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(text: 'Mistake Gym'),
            Tab(text: 'Saved Words'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Mistake Gym (SRS cards with lapses > 0)
          FutureBuilder<List<drift.TypedResult>>(
            future: (db.select(db.srsCards).join([
              drift.innerJoin(db.words, db.words.id.equalsExp(db.srsCards.itemId)),
            ])..where(db.srsCards.lapses.isBiggerThanValue(0)))
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final rows = snapshot.data ?? [];
              if (rows.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline_rounded,
                            size: 64, color: AppColors.correct),
                        const SizedBox(height: 16),
                        Text(
                          'No Active Mistakes!',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Whenever an enemy breaches your gate or you miss a review, it appears here for targeted drill practice.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: AppColors.wrong.withAlpha(20),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.wrong),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${rows.length} words need review. Drill them in Mistake Gym to reinforce memory.',
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.wrong,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const WordSiegeScreen(level: 2, tapMode: true),
                              ),
                            );
                          },
                          child: const Text('Drill Now'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: rows.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final row = rows[index];
                        final word = row.readTable(db.words);
                        final srs = row.readTable(db.srsCards);

                        return Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: AppColors.wrong.withAlpha(80)),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            title: Row(
                              children: [
                                Text(
                                  word.lemma,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                if (word.ipa != null) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    word.ipa!,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.wrong.withAlpha(30),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${srs.lapses} lapses',
                                    style: const TextStyle(
                                      color: AppColors.wrong,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(word.definitionEn ?? 'Vocabulary word'),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent),
                              onPressed: () => audio.speakOrPlay(word.lemma),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),

          // Tab 2: Saved Words & Wild Items
          FutureBuilder<List<WildItem>>(
            future: (db.select(db.wildItems)
                  ..orderBy([(t) => drift.OrderingTerm.desc(t.savedAt)]))
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final items = snapshot.data ?? [];
              if (items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star_border_rounded, size: 64, color: AppColors.combo),
                        const SizedBox(height: 16),
                        Text(
                          'No Saved Words Yet',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the ⭐ star icon after any game round to save challenging words to your personal notebook.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = items[index];

                  return Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: AppColors.combo.withAlpha(80)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.sentence,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent),
                                    onPressed: () => audio.speakOrPlay(item.sentence),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, size: 20),
                                    onPressed: () => _deleteWildItem(item.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (item.source != null && item.source!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              item.source!,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
