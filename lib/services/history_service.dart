import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/identification_result.dart';

/// Keeps a local log of past Identify results so a responder can pull up
/// something they looked up earlier without a network round-trip.
class HistoryService extends ChangeNotifier {
  HistoryService._();
  static final instance = HistoryService._();

  static const _key = 'identification_history';
  static const _maxItems = 20;

  List<IdentificationResult> _items = [];
  List<IdentificationResult> get items => List.unmodifiable(_items);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    _items = raw
        .map((s) => IdentificationResult.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }

  Future<void> add(IdentificationResult result) async {
    _items = [result, ..._items];
    if (_items.length > _maxItems) {
      _items = _items.sublist(0, _maxItems);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _items.map((r) => jsonEncode(r.toJson())).toList());
  }

  Future<void> clear() async {
    _items = [];
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
