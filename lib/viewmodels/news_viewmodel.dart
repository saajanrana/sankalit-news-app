import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/news_model.dart';
import '../services/news_api_service.dart';

// News API service provider
final newsApiServiceProvider = Provider<NewsApiService>((ref) {
  return NewsApiService();
});

// News state
class NewsState {
  final List<NewsModel> news;
  final bool isLoading;
  final String? error;
  final bool hasMore;

  NewsState({
    this.news = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
  });

  NewsState copyWith({
    List<NewsModel>? news,
    bool? isLoading,
    String? error,
    bool? hasMore,
  }) {
    return NewsState(
      news: news ?? this.news,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// News ViewModel
class NewsNotifier extends StateNotifier<NewsState> {
  final NewsApiService _apiService;
  String? _currentCategory;

  NewsNotifier(this._apiService) : super(NewsState());

  // Load news for a specific category
  Future<void> loadNews({String? category, bool refresh = false}) async {
    if (refresh) {
      _currentCategory = category;
      state = state.copyWith(news: [], error: null);
    }

    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final newsList = await _apiService.getMockNews(category: category);
      
      if (refresh) {
        state = state.copyWith(
          news: newsList,
          isLoading: false,
          hasMore: newsList.length >= 20,
        );
      } else {
        state = state.copyWith(
          news: [...state.news, ...newsList],
          isLoading: false,
          hasMore: newsList.length >= 20,
        );
      }
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Load more news (pagination)
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    
    await loadNews(category: _currentCategory, refresh: false);
  }

  // Refresh news
  Future<void> refresh() async {
    await loadNews(category: _currentCategory, refresh: true);
  }
}

// Providers
final newsProvider = StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  final apiService = ref.watch(newsApiServiceProvider);
  return NewsNotifier(apiService);
});

// Category-specific news providers
final categoryNewsProvider = StateNotifierProvider.family<NewsNotifier, NewsState, String>((ref, category) {
  final apiService = ref.watch(newsApiServiceProvider);
  final notifier = NewsNotifier(apiService);
  notifier.loadNews(category: category, refresh: true);
  return notifier;
});