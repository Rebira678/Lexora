import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/services/phase2_content_service.dart';
import '../widgets/what_you_learned_screen.dart';

class MorphLabItem {
  final int id;
  final String root;
  final String sentence;
  final String target;
  final String prefix;
  final String suffix;
  final List<String> availablePrefixes;
  final List<String> availableSuffixes;
  final String explanation;

  MorphLabItem({
    required this.id,
    required this.root,
    required this.sentence,
    required this.target,
    required this.prefix,
    required this.suffix,
    required this.availablePrefixes,
    required this.availableSuffixes,
    required this.explanation,
  });

  factory MorphLabItem.fromJson(Map<String, dynamic> json) {
    return MorphLabItem(
      id: json['id'] as int,
      root: json['root'] as String,
      sentence: json['sentence'] as String,
      target: json['target'] as String,
      prefix: json['prefix'] as String,
      suffix: json['suffix'] as String,
      availablePrefixes: (json['availablePrefixes'] as List).map((p) => p.toString()).toList(),
      availableSuffixes: (json['availableSuffixes'] as List).map((s) => s.toString()).toList(),
      explanation: json['explanation'] as String,
    );
  }
}

class PrefixSuffixLabScreen extends ConsumerStatefulWidget {
  const PrefixSuffixLabScreen({super.key});

  @override
  ConsumerState<PrefixSuffixLabScreen> createState() => _PrefixSuffixLabScreenState();
}

class _PrefixSuffixLabScreenState extends ConsumerState<PrefixSuffixLabScreen> {
  List<MorphLabItem> _items = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  String? _selectedPrefix;
  String? _selectedSuffix;
  bool _hasChecked = false;
  bool _isCorrect = false;

  int _score = 0;
  int _xpEarned = 0;
  int _correctCount = 0;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final data = await Phase2ContentService.instance.loadContent();
      final list = (data['prefix_suffix_lab'] as List)
          .map((m) => MorphLabItem.fromJson(m as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _items = list..shuffle();
        _isLoading = false;
      });

      if (_items.isNotEmpty) {
        ref.read(audioServiceProvider).speakOrPlay(_items.first.root);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _checkMorphology() {
    if (_hasChecked) return;
    final current = _items[_currentIndex];

    // Normalize prefix
    final cleanP = (_selectedPrefix == null || _selectedPrefix == 'none') ? '' : _selectedPrefix!.replaceAll('-', '');
    final cleanS = _selectedSuffix == null ? '' : _selectedSuffix!.replaceAll('-', '');

    // Check if player's choices match the target
    final expectedP = current.prefix.replaceAll('-', '').toLowerCase().trim();
    final expectedS = current.suffix.replaceAll('-', '').toLowerCase().trim();

    final isCorrect = (cleanP.toLowerCase() == expectedP) && (cleanS.toLowerCase() == expectedS);

    setState(() {
      _hasChecked = true;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      _correctCount++;
      _score += 150;
      _xpEarned += 30;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay(current.target);

      _learnedItems.add(
        LearnedItem(
          term: current.target,
          definition: 'Root: ${current.root} • ${current.explanation}',
          example: current.sentence.replaceAll('________', current.target),
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);

      _learnedItems.add(
        LearnedItem(
          term: current.target,
          definition: 'Root: ${current.root} • ${current.explanation}',
          example: current.sentence.replaceAll('________', current.target),
          wasMistake: true,
        ),
      );
    }
  }

  void _next() {
    if (_currentIndex + 1 < _items.length && _currentIndex + 1 < 4) {
      setState(() {
        _currentIndex++;
        _selectedPrefix = null;
        _selectedSuffix = null;
        _hasChecked = false;
        _isCorrect = false;
      });
      ref.read(audioServiceProvider).speakOrPlay(_items[_currentIndex].root);
    } else {
      _endGame();
    }
  }

  Future<void> _endGame() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final durationMs = now - _roundStartTime;
    final total = _currentIndex + 1;
    final accuracy = total == 0 ? 0.0 : _correctCount / total;

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'prefix_suffix_lab',
            mode: const drift.Value('derivational_morphology'),
            level: const drift.Value(3),
            startedAt: _roundStartTime,
            durationMs: durationMs,
            accuracy: accuracy,
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
          gameTitle: '🧪 Prefix & Suffix Lab',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const PrefixSuffixLabScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Prefix & Suffix Lab')),
        body: const Center(child: Text('No morphology lab items found.')),
      );
    }

    final theme = Theme.of(context);
    final current = _items[_currentIndex];
    final total = _items.length < 4 ? _items.length : 4;

    final assembledWord = '${_selectedPrefix == "none" ? "" : (_selectedPrefix ?? "")}${current.root.toLowerCase()}${_selectedSuffix ?? ""}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Prefix & Suffix Lab (${_currentIndex + 1}/$total)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent),
            tooltip: 'Hear Word',
            onPressed: () => ref.read(audioServiceProvider).speakOrPlay(current.root),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Context Sentence
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Text(
                  current.sentence,
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.45),
                ),
              ),
              const SizedBox(height: 20),

              // Word Forge Canvas
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(90),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _hasChecked
                        ? (_isCorrect ? AppColors.correct : AppColors.wrong)
                        : theme.colorScheme.primary.withAlpha(80),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'MORPHOLOGICAL FORGE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Prefix Box
                        _AffixSlot(
                          label: _selectedPrefix ?? 'Prefix',
                          isActive: _selectedPrefix != null,
                          isPrefix: true,
                        ),
                        const SizedBox(width: 8),
                        // Root Box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(35),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: theme.colorScheme.primary, width: 2),
                          ),
                          child: Text(
                            current.root,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Suffix Box
                        _AffixSlot(
                          label: _selectedSuffix ?? 'Suffix',
                          isActive: _selectedSuffix != null,
                          isPrefix: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _hasChecked ? 'Target: ${current.target}' : 'Assembled: $assembledWord',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _hasChecked
                            ? (_isCorrect ? AppColors.correct : AppColors.wrong)
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Affix Palettes
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Choose Prefix:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: current.availablePrefixes.map((p) {
                          final isSel = _selectedPrefix == p;
                          return ChoiceChip(
                            label: Text(p, style: const TextStyle(fontWeight: FontWeight.bold)),
                            selected: isSel,
                            onSelected: _hasChecked ? null : (_) => setState(() => _selectedPrefix = p),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text('Choose Suffix:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: current.availableSuffixes.map((s) {
                          final isSel = _selectedSuffix == s;
                          return ChoiceChip(
                            label: Text(s, style: const TextStyle(fontWeight: FontWeight.bold)),
                            selected: isSel,
                            onSelected: _hasChecked ? null : (_) => setState(() => _selectedSuffix = s),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              // Teacher Derivational Explanation
              if (_hasChecked)
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.psychology_rounded, size: 20, color: AppColors.accent),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          current.explanation,
                          style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),

              // Action button
              if (!_hasChecked)
                ElevatedButton(
                  onPressed: (_selectedPrefix != null || _selectedSuffix != null) ? _checkMorphology : null,
                  child: const Text('Forge & Verify Derivation'),
                )
              else
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_currentIndex + 1 < total ? 'Next Word Lab' : 'Complete Morphology Lab'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AffixSlot extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isPrefix;

  const _AffixSlot({
    required this.label,
    required this.isActive,
    required this.isPrefix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.surface : theme.colorScheme.surface.withAlpha(100),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? theme.colorScheme.primary : theme.colorScheme.outline,
          style: isActive ? BorderStyle.solid : BorderStyle.none,
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant.withAlpha(120),
        ),
      ),
    );
  }
}
