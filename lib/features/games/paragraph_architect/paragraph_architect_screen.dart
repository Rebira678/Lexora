import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../core/scoring/scoring.dart';
import '../../../app/providers.dart';
import '../widgets/what_you_learned_screen.dart';

class ParagraphSentence {
  final int id;
  final String text;

  ParagraphSentence({required this.id, required this.text});
}

class CohesionLink {
  final int from;
  final int to;
  final String cue;
  final String type;

  CohesionLink({
    required this.from,
    required this.to,
    required this.cue,
    required this.type,
  });
}

class ParagraphArchitectScreen extends ConsumerStatefulWidget {
  final int level;

  const ParagraphArchitectScreen({
    super.key,
    this.level = 1,
  });

  @override
  ConsumerState<ParagraphArchitectScreen> createState() => _ParagraphArchitectScreenState();
}

class _ParagraphArchitectScreenState extends ConsumerState<ParagraphArchitectScreen> {
  List<Paragraph> _paragraphs = [];
  int _paragraphIndex = 0;
  Paragraph? _paragraph;
  List<ParagraphSentence> _currentOrder = [];
  List<int> _correctOrder = [];
  List<CohesionLink> _links = [];

  bool _isLoading = true;
  bool _highlightConnectors = false;
  bool _hasChecked = false;
  int _score = 0;
  int _xpEarned = 0;
  double _penaltyMultiplier = 1.0;
  int _roundStartTime = 0;
  final List<LearnedItem> _learnedItems = [];

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadParagraphs();
  }

  Future<void> _loadParagraphs() async {
    final gameDao = ref.read(gameDaoProvider);
    final list = await gameDao.getParagraphsForLevel(widget.level);
    if (!mounted) return;

    List<Paragraph> paras = [];
    if (list.isNotEmpty) {
      paras = List.of(list)..shuffle();
    } else {
      final all = await ref.read(databaseProvider).select(ref.read(databaseProvider).paragraphs).get();
      if (all.isNotEmpty) paras = List.of(all)..shuffle();
    }

    if (paras.isNotEmpty) {
      setState(() {
        _paragraphs = paras;
        _paragraphIndex = 0;
      });
      _setupParagraph(_paragraphs[0]);
    }
  }

  void _setupParagraph(Paragraph chosen) {
    final List<dynamic> rawSentences = json.decode(chosen.sentencesJson);
    final List<dynamic> rawOrders = json.decode(chosen.validOrdersJson);
    final List<dynamic> rawLinks = json.decode(chosen.linksJson);

    final sentences = rawSentences.map((s) => ParagraphSentence(id: s['id'] as int, text: s['text'] as String)).toList();
    final validOrder = (rawOrders.first as List<dynamic>).map((e) => e as int).toList();
    final links = rawLinks
        .map((l) => CohesionLink(
              from: l['from'] as int,
              to: l['to'] as int,
              cue: l['cue'] as String,
              type: l['type'] as String,
            ))
        .toList();

    final shuffled = List<ParagraphSentence>.from(sentences)..shuffle();

    setState(() {
      _paragraph = chosen;
      _currentOrder = shuffled;
      _correctOrder = validOrder;
      _links = links;
      _hasChecked = false;
      _highlightConnectors = false;
      _penaltyMultiplier = 1.0;
      _isLoading = false;
    });
  }

  void _nextParagraph() {
    final total = _paragraphs.length < 3 ? _paragraphs.length : 3;
    if (_paragraphIndex + 1 < total) {
      setState(() {
        _paragraphIndex++;
      });
      _setupParagraph(_paragraphs[_paragraphIndex]);
    } else {
      _endGame();
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (_hasChecked) return;
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _currentOrder.removeAt(oldIndex);
      _currentOrder.insert(newIndex, item);
    });
  }

  void _checkOrder() {
    final playerIds = _currentOrder.map((s) => s.id).toList();
    final rawScore = paragraphArchitectScore(
      playerOrder: playerIds,
      correctOrder: _correctOrder,
      pairPoints: 25,
      exactBonus: 50,
    );

    final finalScore = (rawScore * _penaltyMultiplier).round();
    final isExact = rawScore >= 100;

    setState(() {
      _hasChecked = true;
      _score += finalScore;
      _xpEarned += (finalScore * 0.4).round();
    });

    _learnedItems.add(
      LearnedItem(
        term: 'Paragraph: ${_paragraph?.topic ?? "Topic"}',
        definition: 'Cohesion & connector flow',
        example: isExact ? 'Perfect logical order!' : 'Review transition words',
        wasMistake: !isExact,
      ),
    );

    if (isExact) {
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
    }
  }

  void _useHighlightHelper() {
    setState(() {
      _highlightConnectors = true;
      _penaltyMultiplier -= 0.10;
    });
  }

  void _usePinOpenerHelper() {
    if (_correctOrder.isEmpty) return;
    final openerId = _correctOrder.first;
    final openerIdx = _currentOrder.indexWhere((s) => s.id == openerId);
    if (openerIdx > 0) {
      setState(() {
        final opener = _currentOrder.removeAt(openerIdx);
        _currentOrder.insert(0, opener);
        _penaltyMultiplier -= 0.20;
      });
    }
  }

  Future<void> _endGame() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final durationMs = now - _roundStartTime;
    final accuracy = _score >= 75 ? 1.0 : (_score / 150.0).clamp(0.0, 1.0);

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'paragraph_architect',
            mode: const drift.Value('reorder'),
            level: drift.Value(widget.level),
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
          itemsReviewed: _currentOrder.length,
          goalMet: true,
        );

    final items = _currentOrder.map((s) {
      return LearnedItem(
        term: 'Sentence ${s.id}',
        definition: s.text,
        example: '',
        wasMistake: !_hasChecked || _score < 75,
      );
    }).toList();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WhatYouLearnedScreen(
          gameTitle: '📑 Paragraph Architect',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems.isNotEmpty ? _learnedItems : items,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => ParagraphArchitectScreen(level: widget.level)),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _paragraph == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);

    final maxParas = _paragraphs.length < 3 ? _paragraphs.length : 3;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paragraph Architect (${_paragraphIndex + 1}/$maxParas)',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Helper buttons bar
            if (!_hasChecked)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ActionChip(
                        avatar: const Icon(Icons.highlight, size: 16),
                        label: const Text('Highlight (-10%)', style: TextStyle(fontSize: 11)),
                        onPressed: _highlightConnectors ? null : _useHighlightHelper,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ActionChip(
                        avatar: const Icon(Icons.push_pin, size: 16),
                        label: const Text('Pin First (-20%)', style: TextStyle(fontSize: 11)),
                        onPressed: _usePinOpenerHelper,
                      ),
                    ),
                  ],
                ),
              ),

            // Draggable Sentence Cards List
            Expanded(
              child: ReorderableListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _currentOrder.length,
                onReorder: _onReorder,
                itemBuilder: (context, index) {
                  final sentence = _currentOrder[index];
                  return Card(
                    key: ValueKey(sentence.id),
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: _hasChecked
                            ? (_correctOrder.indexOf(sentence.id) == index ? AppColors.correct : AppColors.wrong)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.accent.withAlpha(50),
                        child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent)),
                      ),
                      title: Text(
                        sentence.text,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: _highlightConnectors ? FontWeight.w600 : FontWeight.normal,
                          color: _highlightConnectors ? AppColors.accentLight : theme.colorScheme.onSurface,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.volume_up_outlined, size: 20),
                            onPressed: () => ref.read(audioServiceProvider).speakOrPlay(sentence.text),
                          ),
                          const Icon(Icons.drag_handle_rounded, color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Cohesion Map view if checked
            if (_hasChecked && _links.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🔗 Cohesion Map', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    ..._links.map((link) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '• "${link.cue}" links Idea ${link.from} ➔ ${link.to} (${link.type})',
                            style: const TextStyle(fontSize: 13),
                          ),
                        )),
                  ],
                ),
              ),

            // Bottom Action
            Padding(
              padding: const EdgeInsets.all(16),
              child: _hasChecked
                  ? ElevatedButton(
                      onPressed: _nextParagraph,
                      child: Text(
                        _paragraphIndex + 1 < maxParas
                            ? 'Next Paragraph (${_paragraphIndex + 1}/$maxParas)'
                            : 'Finish & View Summary',
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _checkOrder,
                      child: const Text('Check Order'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
