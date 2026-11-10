import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/services/phase3_content_service.dart';
import '../games/widgets/what_you_learned_screen.dart';

class StoryChoice {
  final String text;
  final String nextNodeId;
  final String? requiresComprehension;
  final List<String> comprehensionOptions;
  final String? comprehensionAnswer;

  const StoryChoice({
    required this.text,
    required this.nextNodeId,
    this.requiresComprehension,
    this.comprehensionOptions = const [],
    this.comprehensionAnswer,
  });

  factory StoryChoice.fromJson(Map<String, dynamic> json) {
    return StoryChoice(
      text: json['text'] as String,
      nextNodeId: json['nextNodeId'] as String,
      requiresComprehension: json['requiresComprehension'] as String?,
      comprehensionOptions: (json['comprehensionOptions'] as List?)?.map((o) => o.toString()).toList() ?? [],
      comprehensionAnswer: json['comprehensionAnswer'] as String?,
    );
  }
}

class StoryNode {
  final String id;
  final String text;
  final List<String> vocabHighlights;
  final List<StoryChoice> choices;

  const StoryNode({
    required this.id,
    required this.text,
    required this.vocabHighlights,
    required this.choices,
  });

  factory StoryNode.fromJson(Map<String, dynamic> json) {
    return StoryNode(
      id: json['id'] as String,
      text: json['text'] as String,
      vocabHighlights: (json['vocabHighlights'] as List?)?.map((v) => v.toString()).toList() ?? [],
      choices: (json['choices'] as List).map((c) => StoryChoice.fromJson(c as Map<String, dynamic>)).toList(),
    );
  }
}

class StoryBranchScreen extends ConsumerStatefulWidget {
  const StoryBranchScreen({super.key});

  @override
  ConsumerState<StoryBranchScreen> createState() => _StoryBranchScreenState();
}

class _StoryBranchScreenState extends ConsumerState<StoryBranchScreen> {
  String _storyTitle = 'The Cipher of Oakhaven';
  Map<String, StoryNode> _nodes = {};
  String _currentNodeId = 'intro';
  bool _isLoading = true;

  // Comprehension checkpoint
  StoryChoice? _pendingChoice;
  String? _selectedComprehensionOption;
  bool _hasCheckedComprehension = false;
  bool _isComprehensionCorrect = false;

  int _score = 0;
  int _xpEarned = 0;
  int _nodesVisited = 0;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadStory();
  }

  Future<void> _loadStory() async {
    try {
      final data = await Phase3ContentService.instance.loadContent();
      final list = data['story_branch'] as List;
      if (list.isNotEmpty) {
        final story = list.first as Map<String, dynamic>;
        _storyTitle = story['title'] as String;
        final rawNodes = story['nodes'] as Map<String, dynamic>;
        final nodesMap = <String, StoryNode>{};
        rawNodes.forEach((k, v) {
          nodesMap[k] = StoryNode.fromJson(v as Map<String, dynamic>);
        });

        if (!mounted) return;
        setState(() {
          _nodes = nodesMap;
          _currentNodeId = story['initialNodeId'] as String? ?? 'intro';
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _onSelectChoice(StoryChoice choice) {
    if (choice.requiresComprehension != null && choice.comprehensionOptions.isNotEmpty) {
      // Trigger comprehension modal/sheet
      setState(() {
        _pendingChoice = choice;
        _selectedComprehensionOption = null;
        _hasCheckedComprehension = false;
        _isComprehensionCorrect = false;
      });
    } else {
      _advanceToNode(choice.nextNodeId);
    }
  }

  void _verifyComprehension() {
    if (_selectedComprehensionOption == null || _pendingChoice == null) return;
    final isCorrect = _selectedComprehensionOption == _pendingChoice!.comprehensionAnswer;

    setState(() {
      _hasCheckedComprehension = true;
      _isComprehensionCorrect = isCorrect;
    });

    if (isCorrect) {
      _score += 100;
      _xpEarned += 25;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      _learnedItems.add(
        LearnedItem(
          term: 'Story Inference Checkpoint',
          definition: _pendingChoice!.requiresComprehension!,
          example: 'Correct deduction: ${_pendingChoice!.comprehensionAnswer}',
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
    }
  }

  void _advanceToNode(String nextId) {
    setState(() {
      _currentNodeId = nextId;
      _pendingChoice = null;
      _nodesVisited++;
      _score += 50;
      _xpEarned += 15;
    });

    final current = _nodes[_currentNodeId];
    if (current != null && current.choices.isEmpty) {
      // Reached ending!
      ref.read(audioServiceProvider).playSfx(SfxType.levelUp);
    }
  }

  Future<void> _finishStory() async {
    final durationMs = DateTime.now().millisecondsSinceEpoch - _roundStartTime;

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'story_branch',
            mode: const drift.Value('narrative'),
            level: const drift.Value(3),
            startedAt: _roundStartTime,
            durationMs: durationMs,
            accuracy: 1.0,
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
          itemsReviewed: _nodesVisited,
          goalMet: true,
        );

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WhatYouLearnedScreen(
          gameTitle: '📖 Story Branch: $_storyTitle',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: 1.0,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const StoryBranchScreen()),
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
    if (_nodes.isEmpty || !_nodes.containsKey(_currentNodeId)) {
      return Scaffold(
        appBar: AppBar(title: Text(_storyTitle)),
        body: const Center(child: Text('No story chapters found.')),
      );
    }

    final theme = Theme.of(context);
    final node = _nodes[_currentNodeId]!;
    final isEnding = node.choices.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(_storyTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Narrative Text Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withAlpha(20),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isEnding ? 'RESOLUTION' : 'SCENE',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accent),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent, size: 20),
                          onPressed: () => ref.read(audioServiceProvider).speakOrPlay(node.text),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      node.text,
                      style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w500),
                    ),
                    if (node.vocabHighlights.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: node.vocabHighlights.map((v) {
                          return ActionChip(
                            label: Text(v, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: () => ref.read(audioServiceProvider).speakOrPlay(v),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Comprehension Checkpoint (if choice selected)
              if (_pendingChoice != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.colorScheme.primary.withAlpha(80)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.psychology_rounded, color: theme.colorScheme.primary, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'COMPREHENSION GATEWAY',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: theme.colorScheme.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _pendingChoice!.requiresComprehension!,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      ..._pendingChoice!.comprehensionOptions.map((opt) {
                        final isSel = _selectedComprehensionOption == opt;
                        Color cColor = theme.colorScheme.surface;
                        if (_hasCheckedComprehension) {
                          if (opt == _pendingChoice!.comprehensionAnswer) {
                            cColor = AppColors.correct.withAlpha(30);
                          } else if (isSel) {
                            cColor = AppColors.wrong.withAlpha(30);
                          }
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: cColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: isSel ? theme.colorScheme.primary : theme.colorScheme.outline),
                            ),
                            child: InkWell(
                              onTap: _hasCheckedComprehension ? null : () => setState(() => _selectedComprehensionOption = opt),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(opt, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                                    if (_hasCheckedComprehension && opt == _pendingChoice!.comprehensionAnswer)
                                      const Icon(Icons.check_circle_rounded, color: AppColors.correct, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      if (!_hasCheckedComprehension)
                        ElevatedButton(
                          onPressed: _selectedComprehensionOption != null ? _verifyComprehension : null,
                          child: const Text('Unlock Pathway'),
                        )
                      else if (_isComprehensionCorrect)
                        ElevatedButton(
                          onPressed: () => _advanceToNode(_pendingChoice!.nextNodeId),
                          child: const Text('Proceed down chosen branch'),
                        )
                      else
                        OutlinedButton(
                          onPressed: () => setState(() => _pendingChoice = null),
                          child: const Text('Choose a different path'),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ] else if (!isEnding) ...[
                Text(
                  'CHOOSE YOUR ACTION:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 10),
                ...node.choices.map((choice) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () => _onSelectChoice(choice),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              choice.text,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                        ],
                      ),
                    ),
                  );
                }),
              ] else ...[
                ElevatedButton(
                  onPressed: _finishStory,
                  child: const Text('Complete Narrative Adventure'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
