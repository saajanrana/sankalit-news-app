class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://newsapi.org/v2/';
  static const String apiKey = 'YOUR_NEWS_API_KEY'; // Replace with actual API key

  // Endpoints
  static const String topHeadlinesEndpoint = 'top-headlines';
  static const String everythingEndpoint = 'everything';
  static const String sourcesEndpoint = 'sources';

  // Categories
  static const List<String> categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  // Video URLs (Mock data for demo)
  static const List<String> videoUrls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
  ];

  // Pagination
  static const int pageSize = 20;

  // Local Storage Keys
  static const String bookmarksKey = 'bookmarks';
  static const String themeKey = 'theme_mode';
}

class AppStrings {
  static const String appName = 'News App';
  static const String home = 'Home';
  static const String categories = 'Categories';
  static const String videoNews = 'Video News';
  static const String bookmarks = 'Bookmarks';
  static const String contactUs = 'Contact Us';
  static const String profile = 'Profile';
  static const String settings = 'Settings';
  static const String about = 'About';
  static const String logout = 'Logout';
  static const String darkMode = 'Dark Mode';
  static const String share = 'Share';
  static const String bookmark = 'Bookmark';
  static const String readMore = 'Read More';
  static const String noDataFound = 'No data found';
  static const String error = 'Error';
  static const String retry = 'Retry';
}
