import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';

// Category state
class CategoryState {
  final List<CategoryModel> categories;
  final String selectedCategory;

  CategoryState({
    this.categories = const [],
    this.selectedCategory = 'general',
  });

  CategoryState copyWith({
    List<CategoryModel>? categories,
    String? selectedCategory,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

// Category ViewModel
class CategoryNotifier extends StateNotifier<CategoryState> {
  CategoryNotifier() : super(CategoryState(categories: CategoryModel.getCategories()));

  void selectCategory(String categoryId) {
    state = state.copyWith(selectedCategory: categoryId);
  }
}

// Provider
final categoryProvider = StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
  return CategoryNotifier();
});