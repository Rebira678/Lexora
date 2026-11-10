import 'dart:convert';
import 'package:flutter/services.dart';

class ReferenceHunterItem {
  final int id;
  final String sentence;
  final int level;
  final String pronoun;
  final int pronounIndex;
  final String antecedent;
  final String antecedentSpan;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  ReferenceHunterItem({
    required this.id,
    required this.sentence,
    required this.level,
    required this.pronoun,
    required this.pronounIndex,
    required this.antecedent,
    required this.antecedentSpan,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });

  factory ReferenceHunterItem.fromJson(Map<String, dynamic> json) {
    return ReferenceHunterItem(
      id: json['id'] as int,
      sentence: json['sentence'] as String,
      level: json['level'] as int? ?? 4,
      pronoun: json['pronoun'] as String,
      pronounIndex: json['pronoun_index'] as int? ?? 0,
      antecedent: json['antecedent'] as String,
      antecedentSpan: json['antecedent_span'] as String? ?? '0-0',
      options: (json['options'] as List).map((e) => e.toString()).toList(),
      correctOptionIndex: json['correct_option_index'] as int? ?? 0,
      explanation: json['explanation'] as String,
    );
  }
}

class SentenceRaceItem {
  final int id;
  final String sentence;
  final int level;
  final int wordCount;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  SentenceRaceItem({
    required this.id,
    required this.sentence,
    required this.level,
    required this.wordCount,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory SentenceRaceItem.fromJson(Map<String, dynamic> json) {
    return SentenceRaceItem(
      id: json['id'] as int,
      sentence: json['sentence'] as String,
      level: json['level'] as int? ?? 4,
      wordCount: json['word_count'] as int? ?? (json['sentence'] as String).split(' ').length,
      question: json['question'] as String,
      options: (json['options'] as List).map((e) => e.toString()).toList(),
      correctIndex: json['correct_index'] as int? ?? 0,
      explanation: json['explanation'] as String,
    );
  }
}

class Section20ContentService {
  static final Section20ContentService _instance = Section20ContentService._internal();
  factory Section20ContentService() => _instance;
  Section20ContentService._internal();

  List<ReferenceHunterItem>? _cachedReferences;
  List<SentenceRaceItem>? _cachedRaces;

  Future<void> _load() async {
    if (_cachedReferences != null && _cachedRaces != null) return;
    try {
      final jsonStr = await rootBundle.loadString('assets/content/section20_content.json');
      final data = json.decode(jsonStr) as Map<String, dynamic>;

      if (data['reference_hunter'] != null) {
        _cachedReferences = (data['reference_hunter'] as List)
            .map((item) => ReferenceHunterItem.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        _cachedReferences = [];
      }

      if (data['sentence_race'] != null) {
        _cachedRaces = (data['sentence_race'] as List)
            .map((item) => SentenceRaceItem.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        _cachedRaces = [];
      }
    } catch (e) {
      _cachedReferences = [];
      _cachedRaces = [];
    }
  }

  Future<List<ReferenceHunterItem>> getReferenceItems({int? level}) async {
    await _load();
    final items = _cachedReferences ?? [];
    if (level == null) return items;
    final filtered = items.where((it) => it.level == level).toList();
    return filtered.isNotEmpty ? filtered : items;
  }

  Future<List<SentenceRaceItem>> getSentenceRaceItems({int? level}) async {
    await _load();
    final items = _cachedRaces ?? [];
    if (level == null) return items;
    final filtered = items.where((it) => it.level == level).toList();
    return filtered.isNotEmpty ? filtered : items;
  }
}
