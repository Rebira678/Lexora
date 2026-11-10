import 'dart:convert';
import 'package:flutter/services.dart';

class Phase5ContentService {
  Phase5ContentService._();
  static final Phase5ContentService instance = Phase5ContentService._();

  Map<String, dynamic>? _cachedData;

  Future<Map<String, dynamic>> loadContent() async {
    if (_cachedData != null) return _cachedData!;
    final jsonStr = await rootBundle.loadString('assets/content/phase5_content.json');
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
