class VideoNewsModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final DateTime publishedAt;
  final String duration;

  VideoNewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.publishedAt,
    required this.duration,
  });

  static List<VideoNewsModel> getMockVideos() {
    return [
      VideoNewsModel(
        id: '1',
        title: 'Breaking: Technology Advances in 2024',
        description: 'Latest developments in artificial intelligence and machine learning',
        videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        thumbnailUrl: 'https://images.pexels.com/photos/5380664/pexels-photo-5380664.jpeg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        duration: '3:45',
      ),
      VideoNewsModel(
        id: '2',
        title: 'Global Market Update',
        description: 'Stock market analysis and economic trends for this week',
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        thumbnailUrl: 'https://images.pexels.com/photos/590020/pexels-photo-590020.jpg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        duration: '5:20',
      ),
      VideoNewsModel(
        id: '3',
        title: 'Climate Change Report',
        description: 'New findings on environmental changes and sustainability efforts',
        videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        thumbnailUrl: 'https://images.pexels.com/photos/1108572/pexels-photo-1108572.jpeg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        duration: '4:15',
      ),
    ];
  }
}