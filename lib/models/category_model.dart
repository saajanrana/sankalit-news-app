class CategoryModel {
  final String id;
  final String name;
  final String displayName;
  final String iconPath;

  CategoryModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.iconPath,
  });

  static List<CategoryModel> getCategories() {
    return [
      CategoryModel(
        id: 'general',
        name: 'general',
        displayName: 'General',
        iconPath: '📰',
      ),
      CategoryModel(
        id: 'business',
        name: 'business',
        displayName: 'Business',
        iconPath: '💼',
      ),
      CategoryModel(
        id: 'entertainment',
        name: 'entertainment',
        displayName: 'Entertainment',
        iconPath: '🎬',
      ),
      CategoryModel(
        id: 'health',
        name: 'health',
        displayName: 'Health',
        iconPath: '🏥',
      ),
      CategoryModel(
        id: 'science',
        name: 'science',
        displayName: 'Science',
        iconPath: '🔬',
      ),
      CategoryModel(
        id: 'sports',
        name: 'sports',
        displayName: 'Sports',
        iconPath: '⚽',
      ),
      CategoryModel(
        id: 'technology',
        name: 'technology',
        displayName: 'Technology',
        iconPath: '💻',
      ),
    ];
  }
}