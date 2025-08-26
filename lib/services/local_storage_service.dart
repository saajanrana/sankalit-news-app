import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_model.dart';
import '../core/constants.dart';

class LocalStorageService {
  static late final Box<NewsModel> _bookmarksBox;
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _bookmarksBox = await Hive.openBox<NewsModel>(AppConstants.bookmarksKey);
    _prefs = await SharedPreferences.getInstance();
  }

  // Bookmark operations
  static Future<void> addBookmark(NewsModel news) async {
    await _bookmarksBox.put(news.url, news);
  }

  static Future<void> removeBookmark(String url) async {
    await _bookmarksBox.delete(url);
  }

  static bool isBookmarked(String url) {
    return _bookmarksBox.containsKey(url);
  }

  static List<NewsModel> getBookmarks() {
    return _bookmarksBox.values.toList();
  }

  static Future<void> clearBookmarks() async {
    await _bookmarksBox.clear();
  }

  // Theme preference
  static Future<void> setThemeMode(bool isDarkMode) async {
    await _prefs.setBool(AppConstants.themeKey, isDarkMode);
  }

  static bool getThemeMode() {
    return _prefs.getBool(AppConstants.themeKey) ?? false;
  }

  // Generic preferences
  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }
}
