import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/quiz_data.dart';

class QuizService extends ChangeNotifier {
  QuizService._();
  static final instance = QuizService._();

  static const _keyPrefix = 'quiz_best_';

  Map<QuizCategory, int> _bestScores = {};
  int bestScoreFor(QuizCategory category) => _bestScores[category] ?? 0;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _bestScores = {
      for (final c in QuizCategory.values) c: prefs.getInt('$_keyPrefix${c.name}') ?? 0,
    };
    notifyListeners();
  }

  Future<void> recordScore(QuizCategory category, int score) async {
    if (score <= bestScoreFor(category)) return;
    _bestScores[category] = score;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_keyPrefix${category.name}', score);
  }
}
