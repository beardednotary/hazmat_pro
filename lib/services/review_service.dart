import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  ReviewService._();
  static final instance = ReviewService._();

  static const _shownKey = 'review_shown';
  static const _tabsKey = 'visited_tabs';

  // In-memory guard prevents a race if two triggers fire before the prefs write lands
  bool _shownThisSession = false;

  Future<void> onTabVisited(int index) async {
    final prefs = await SharedPreferences.getInstance();
    if (_shownThisSession || prefs.getBool(_shownKey) == true) return;
    final visited = (prefs.getStringList(_tabsKey) ?? []).toSet()
      ..add(index.toString());
    await prefs.setStringList(_tabsKey, visited.toList());
    if (visited.length >= 4) await _request(prefs);
  }

  Future<void> onSearchSuccess() async {
    final prefs = await SharedPreferences.getInstance();
    await _request(prefs);
  }

  Future<void> onStarThreshold() async {
    final prefs = await SharedPreferences.getInstance();
    await _request(prefs);
  }

  Future<void> _request(SharedPreferences prefs) async {
    if (_shownThisSession) return;
    if (prefs.getBool(_shownKey) == true) return;
    _shownThisSession = true;
    await prefs.setBool(_shownKey, true);
    final review = InAppReview.instance;
    if (await review.isAvailable()) {
      await review.requestReview();
    }
  }
}
