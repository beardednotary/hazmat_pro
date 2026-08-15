import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StarService extends ChangeNotifier {
  StarService._();
  static final instance = StarService._();

  static const _key = 'starred_un_numbers';
  Set<String> _starred = {};

  int get count => _starred.length;
  bool isStarred(String unNumber) => _starred.contains(unNumber);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _starred = (prefs.getStringList(_key) ?? []).toSet();
    notifyListeners();
  }

  Future<void> toggle(String unNumber) async {
    if (_starred.contains(unNumber)) {
      _starred.remove(unNumber);
    } else {
      _starred.add(unNumber);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _starred.toList());
  }
}
