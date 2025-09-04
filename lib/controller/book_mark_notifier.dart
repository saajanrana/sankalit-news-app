import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsBookmarkNotifier extends StateNotifier<List<int>> {
  NewsBookmarkNotifier() : super([]) {
    _loadBookmarks(); // Load from SharedPreferences on startup
  }

  /// Load saved bookmarks from SharedPreferences
  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString("bookmarkedNews");

    if (savedData != null) {
      final List<dynamic> ids = jsonDecode(savedData);
      state = ids.cast<int>(); // update state with saved list
    }
  }

  /// Add news ID
  Future<void> addBookmark(int newsId) async {
    if (!state.contains(newsId)) {
      final updated = [...state, newsId];
      state = updated;
      await _saveToPrefs(updated);
    }
  }

  /// Remove news ID
  Future<void> removeBookmark(int newsId) async {
    final updated = state.where((id) => id != newsId).toList();
    state = updated;
    await _saveToPrefs(updated);
  }

  /// Toggle (add/remove)
  Future<void> toggleBookmark(int newsId) async {
    if (state.contains(newsId)) {
      await removeBookmark(newsId);
    } else {
      await addBookmark(newsId);
    }
  }

  /// Save to SharedPreferences
  Future<void> _saveToPrefs(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("bookmarkedNews", jsonEncode(ids));
  }
}

final newsBookmarkProvider = StateNotifierProvider<NewsBookmarkNotifier, List<int>>(
  (ref) => NewsBookmarkNotifier(),
);
