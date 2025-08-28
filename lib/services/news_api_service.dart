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
        title:
            'मुख्यमंत्री श्री पुष्कर सिंह धामी ने प्रधानमंत्री श्री नरेंद्र मोदी एवं केंद्रीय ऊर्जा मंत्री प्रधानमंत्री श्री नरेंद्र मोदी एवं केंद्रीय ऊर्जा मंत्री प्रधानमंत्री श्री नरेंद्र मोदी एवं केंद्रीय ऊर्जा मंत्री प्रधानमंत्री श्री नरेंद्र मोदी एवं केंद्रीय ऊर्जा मंत्री,',
        description:
            'केंद्र सरकार द्वारा यूपीसीएल, उत्तराखण्ड द्वारा ऋषिकेश के गंगा  कॉरिडोर में एच.टी./एल.टी. लाइनों के भूमिगतकरण एवं एससीएडीए ऑटोमेशन हेतु  कुल परियोजना लागत ₹547.73 करोड़ (समानांतर जीबीएस ₹493.05 करोड़ सहित) तथा पी.एम.ए. शुल्क @ 1.5% परियोजना लागत (₹8.22 करोड़, जिसमें जीबीएस ₹7.39  करोड़) के साथ योजना को स्वीकृति प्रदान की गई है | इस परियोजना के अंतर्गत ऋषिकेश के महत्वपूर्ण क्षेत्रों में एचटी/एलटी विद्युत लाइनों को भूमिगत  किया जाएगा, साथ ही SCADA ऑटोमेशन प्रणाली भी लागू की जाएगी, जिससे बिजली  आपूर्ति में पारदर्शिता, निगरानी और त्वरित सुधार की क्षमता विकसित होगी।उत्तराखण्ड के मुख्यमंत्री श्री पुष्कर सिंह धामी ने ऋषिकेश के गंगा  कॉरिडोर क्षेत्र में विद्युत लाइनों के भूमिगतकरण एवं ऑटोमेशन के लिए पावर  फाइनेंस कॉरपोरेशन लिमिटेड (पीएफसी) द्वारा ₹547.73 करोड़ की परियोजना को  अनुमोदित किए जाने पर प्रधानमंत्री श्री नरेंद्र मोदी एवं केंद्रीय ऊर्जा  मंत्री श्री मनोहर लाल खट्टर का हार्दिक आभार व्यक्त किया है। मुख्यमंत्री  श्री पुष्कर सिंह धामी ने इस संबंध में केंद्र सरकार से अनुरोध किया था   ऋषिकेश जैसे आध्यात्मिक, पर्यटन और कुम्भ क्षेत्र के लिए यह परियोजना न  केवल विद्युत व्यवस्था को सुदृढ़ बनाएगी, बल्कि नगर की सौंदर्यकरण ,  सुरक्षा और पर्यावरणीय संतुलन में भी महत्वपूर्ण भूमिका निभाएगी।  उत्तराखण्ड सरकार इस परियोजना को समयबद्ध रूप से लागू करने के लिए पूर्ण  प्रतिबद्धता के साथ कार्य करेगी, जिससे प्रदेशवासियों को गुणवत्तापूर्ण,  सतत और सुरक्षित विद्युत आपूर्ति सुनिश्चित हो सके।',
        url: 'https://example.com/flutter-4-released',
        urlToImage: 'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcS73YSTZ2QCqhzVufhV1vfFkT-h3ErTAROexkMsh8xgje5MH5x0',
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        author: 'उत्तराखण्ड',
        // state: 'उत्तराखण्ड',
        source: SourceModel(id: 'tech-news', name: 'Tech News'),
      ),
      NewsModel(
        title: 'मुख्यमंत्री श्री पुष्कर सिंह धामी ने प्रधानमंत्री श्री नरेंद्र मोदी एवं केंद्रीय ऊर्जा मंत्री...... ',
        description: 'केंद्र सरकार द्वारा यूपीसीएल, उत्तराखण्ड द्वारा ऋषिकेश के गंगा कॉरिडोर ..',
        url: 'https://example.com/flutter-4-released',
        urlToImage: 'https://images.bhaskarassets.com/web2images/1884/2025/07/04/1001022176_1751605741.jpg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        author: 'उत्तराखण्ड',
        // state: 'उत्तराखण्ड',
        source: SourceModel(id: 'tech-news', name: 'Tech News'),
      ),
      NewsModel(
        title: 'मुख्यमंत्री श्री पुष्कर सिंह धामी ने प्रधानमंत्री श्री नरेंद्र मोदी एवं केंद्रीय ऊर्जा मंत्री... ',
        description: 'केंद्र सरकार द्वारा यूपीसीएल, उत्तराखण्ड द्वारा ऋषिकेश के गंगा कॉरिडोर ..',
        url: 'https://example.com/flutter-4-released',
        urlToImage: 'https://sankalit.com/post_images/ALZE59.jpg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        author: 'उत्तराखण्ड',
        // state: 'उत्तराखण्ड',
        source: SourceModel(id: 'tech-news', name: 'Tech News'),
      ),
      NewsModel(
        title: 'मुख्यमंत्री श्री पुष्कर सिंह धामी ने प्रधानमंत्री श्री नरेंद्र मोदी एवं केंद्रीय ऊर्जा मंत्री...... ',
        description: 'केंद्र सरकार द्वारा यूपीसीएल, उत्तराखण्ड द्वारा ऋषिकेश के गंगा कॉरिडोर ..',
        url: 'https://example.com/flutter-4-released',
        urlToImage: 'https://sankalit.com/post_images/I37596.jpg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        author: 'उत्तराखण्ड',
        // state: 'उत्तराखण्ड',
        source: SourceModel(id: 'tech-news', name: 'Tech News'),
      ),
    ];
  }
}
