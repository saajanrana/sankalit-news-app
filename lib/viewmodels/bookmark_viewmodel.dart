import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/news_model.dart';
import '../services/local_storage_service.dart';

// Bookmark state
class BookmarkState {
  final List<NewsModel> bookmarks;
  final bool isLoading;

  BookmarkState({
    this.bookmarks = const [],
    this.isLoading = false,
  });

  BookmarkState copyWith({
    List<NewsModel>? bookmarks,
    bool? isLoading,
  }) {
    return BookmarkState(
      bookmarks: bookmarks ?? this.bookmarks,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Bookmark ViewModel
class BookmarkNotifier extends StateNotifier<BookmarkState> {
  BookmarkNotifier() : super(BookmarkState()) {
    loadBookmarks();
  }

  void loadBookmarks() {
    state = state.copyWith(isLoading: true);
    try {
      final bookmarks = LocalStorageService.getBookmarks();
      state = state.copyWith(bookmarks: bookmarks, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> toggleBookmark(NewsModel news) async {
    try {
      if (isBookmarked(news.url)) {
        await LocalStorageService.removeBookmark(news.url);
      } else {
        await LocalStorageService.addBookmark(news);
      }
      loadBookmarks(); // Refresh the list
    } catch (e) {
      // Handle error
    }
  }

  bool isBookmarked(String url) {
    return LocalStorageService.isBookmarked(url);
  }

  Future<void> clearAllBookmarks() async {
    try {
      await LocalStorageService.clearBookmarks();
      state = state.copyWith(bookmarks: []);
    } catch (e) {
      // Handle error
    }
  }
}

// Provider
final bookmarkProvider = StateNotifierProvider<BookmarkNotifier, BookmarkState>((ref) {
  return BookmarkNotifier();
});