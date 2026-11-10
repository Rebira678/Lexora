import 'dart:convert';
import 'package:flutter/services.dart';

class Phase4ContentService {
  Phase4ContentService._();
  static final Phase4ContentService instance = Phase4ContentService._();

  Map<String, dynamic>? _cachedData;

  Future<Map<String, dynamic>> loadContent() async {
    if (_cachedData != null) return _cachedData!;
    final jsonStr = await rootBundle.loadString('assets/content/phase4_content.json');
    _cachedData = json.decode(jsonStr) as Map<String, dynamic>;
    return _cachedData!;
  }

  void prime(Map<String, dynamic> data) {
    _cachedData = data;
  }

  void clear() {
    _cachedData = null;
  }
}
