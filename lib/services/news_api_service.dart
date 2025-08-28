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
            '<p>मुख्यमंत्री ने सेवादान आरोग्य संस्था से किच्छा स्थित एम्स सैटेलाइट सेंटर में भी यह व्यवस्था करने की बात कही , जिस पर संस्था ने सहमति व्यक्त की। इस एम.ओ.यू. के तहत सेवादान आरोग्य फाउंडेशन, राजकीय मेडिकल कॉलेज हल्द्वानी एवं देहरादून में तीमारदारों के लिए विश्राम गृहों का निर्माण करेगा। दोनों मेडिकल कॉलेजों में 350 बिस्तरों की क्षमता वाले विश्राम गृहों का निर्माण प्रस्तावित है।इन विश्राम गृहों (रैन बसेरों) में रात्रि विश्राम के लिए शयनागार में ₹55 प्रति बिस्तर तथा दो बिस्तरों वाले कमरे ₹300 प्रति कक्ष की दर से उपलब्ध कराए जाएंगे। साथ ही, नाश्ता ₹20 तथा भोजन ₹35 की सस्ती दरों पर उपलब्ध कराया जाएगा।इन विश्राम गृहों का संचालन एवं रखरखाव सेवादान आरोग्य फाउंडेशन द्वारा किया जाएगा। राजकीय मेडिकल कॉलेज देहरादून द्वारा 1750 वर्गमीटर एवं राजकीय मेडिकल कॉलेज हल्द्वानी द्वारा 1400 वर्गमीटर भूमि विश्राम गृहों के निर्माण हेतु प्रदान की जाएगी। यह एम.ओ.यू. आगामी 20 वर्षों के लिए वैध रहेगा।इस अवसर पर स्वास्थ्य मंत्री डॉ. धन सिंह रावत, सचिव स्वास्थ्य डॉ. आर. राजेश कुमार, सचिव श्री विनय शंकर पाण्डेय, निदेशक चिकित्सा शिक्षा डॉ. आशुतोष सयाना तथा सेवादान आरोग्य संस्था से श्री अभिषेक सक्सेना, श्री आनंद सिंह बिसेन एवं श्री अमित दास उपस्थित थे।</p>\r\n',
        url: 'https://example.com/flutter-4-released',
        urlToImage:
            'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcS73YSTZ2QCqhzVufhV1vfFkT-h3ErTAROexkMsh8xgje5MH5x0',
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        author: 'उत्तराखण्ड',
        // state: 'उत्तराखण्ड',
        source: SourceModel(id: 'tech-news', name: 'Tech News'),
      ),
      NewsModel(
        title:
            'मुख्यमंत्री श्री पुष्कर सिंह धामी ने प्रधानमंत्री श्री नरेंद्र मोदी एवं केंद्रीय ऊर्जा मंत्री...... ',
        description:
            'केंद्र सरकार द्वारा यूपीसीएल, उत्तराखण्ड द्वारा ऋषिकेश के गंगा कॉरिडोर ..',
        url: 'https://example.com/flutter-4-released',
        urlToImage:
            'https://images.bhaskarassets.com/web2images/1884/2025/07/04/1001022176_1751605741.jpg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        author: 'उत्तराखण्ड',
        // state: 'उत्तराखण्ड',
        source: SourceModel(id: 'tech-news', name: 'Tech News'),
      ),
      NewsModel(
        title:
            'मुख्यमंत्री श्री पुष्कर सिंह धामी ने प्रधानमंत्री श्री नरेंद्र मोदी एवं केंद्रीय ऊर्जा मंत्री... ',
        description:
            'केंद्र सरकार द्वारा यूपीसीएल, उत्तराखण्ड द्वारा ऋषिकेश के गंगा कॉरिडोर ..',
        url: 'https://example.com/flutter-4-released',
        urlToImage: 'https://sankalit.com/post_images/ALZE59.jpg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        author: 'उत्तराखण्ड',
        // state: 'उत्तराखण्ड',
        source: SourceModel(id: 'tech-news', name: 'Tech News'),
      ),
      NewsModel(
        title:
            'मुख्यमंत्री श्री पुष्कर सिंह धामी ने प्रधानमंत्री श्री नरेंद्र मोदी एवं केंद्रीय ऊर्जा मंत्री...... ',
        description:
            'केंद्र सरकार द्वारा यूपीसीएल, उत्तराखण्ड द्वारा ऋषिकेश के गंगा कॉरिडोर ..',
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