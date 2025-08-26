import 'package:dio/dio.dart';
import '../core/constants.dart';
import '../models/news_model.dart';

class NewsApiService {
  final Dio _dio = Dio();

  NewsApiService() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  // Get top headlines
  Future<List<NewsModel>> getTopHeadlines({
    String? category,
    String? country = 'us',
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.topHeadlinesEndpoint,
        queryParameters: {
          'apiKey': AppConstants.apiKey,
          'category': category,
          'country': country,
          'page': page,
          'pageSize': AppConstants.pageSize,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> articles = response.data['articles'] ?? [];
        return articles.map((json) => NewsModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load news');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Search everything
  Future<List<NewsModel>> searchEverything({
    required String query,
    String? sortBy = 'publishedAt',
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.everythingEndpoint,
        queryParameters: {
          'apiKey': AppConstants.apiKey,
          'q': query,
          'sortBy': sortBy,
          'page': page,
          'pageSize': AppConstants.pageSize,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> articles = response.data['articles'] ?? [];
        return articles.map((json) => NewsModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search news');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get mock data for development
  Future<List<NewsModel>> getMockNews({String? category}) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    return [
      NewsModel(
        title: 'Breaking News: Flutter 4.0 Released with Amazing Features',
        description: 'Google releases Flutter 4.0 with improved performance, new widgets, and enhanced development tools.',
        url: 'https://example.com/flutter-4-released',
        urlToImage: 'https://images.pexels.com/photos/4164418/pexels-photo-4164418.jpeg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        author: 'Tech Reporter',
        content: 'Flutter 4.0 brings revolutionary changes to mobile development...',
        source: SourceModel(id: 'tech-news', name: 'Tech News'),
      ),
      NewsModel(
        title: 'Global Climate Summit Reaches Historic Agreement',
        description: 'World leaders unite on comprehensive climate action plan for the next decade.',
        url: 'https://example.com/climate-summit-agreement',
        urlToImage: 'https://images.pexels.com/photos/1108572/pexels-photo-1108572.jpeg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
        author: 'Environmental Correspondent',
        content: 'The historic agreement includes ambitious targets...',
        source: SourceModel(id: 'global-news', name: 'Global News'),
      ),
      NewsModel(
        title: 'Stock Market Reaches New All-Time High',
        description: 'Major indices surge as investors show confidence in economic recovery.',
        url: 'https://example.com/stock-market-high',
        urlToImage: 'https://images.pexels.com/photos/590020/pexels-photo-590020.jpg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        author: 'Financial Analyst',
        content: 'The market rally continues with strong performance...',
        source: SourceModel(id: 'finance-times', name: 'Finance Times'),
      ),
      NewsModel(
        title: 'AI Revolution: New Breakthrough in Machine Learning',
        description: 'Scientists develop advanced AI model that can understand context better than ever before.',
        url: 'https://example.com/ai-breakthrough',
        urlToImage: 'https://images.pexels.com/photos/5380664/pexels-photo-5380664.jpeg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 7)),
        author: 'AI Researcher',
        content: 'The new model demonstrates unprecedented capabilities...',
        source: SourceModel(id: 'ai-today', name: 'AI Today'),
      ),
      NewsModel(
        title: 'Sports Update: Championship Finals Set for This Weekend',
        description: 'Two powerhouse teams prepare for the ultimate showdown in championship finals.',
        url: 'https://example.com/championship-finals',
        urlToImage: 'https://images.pexels.com/photos/114296/pexels-photo-114296.jpeg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 9)),
        author: 'Sports Reporter',
        content: 'Fans eagerly await the championship match...',
        source: SourceModel(id: 'sports-central', name: 'Sports Central'),
      ),
    ];
  }
}