import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryState {
  final Map<String, dynamic> categories;
  const CategoryState({this.categories = const {}});

  CategoryState copyWith({Map<String, dynamic>? categories}) {
    return CategoryState(categories: categories ?? this.categories);
  }
}

class CategoryNotifier extends StateNotifier<CategoryState> {
  CategoryNotifier() : super(const CategoryState());

  void setCategories(Map<String, dynamic> categories) {
    state = state.copyWith(categories: categories);
  }
}

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
  return CategoryNotifier();
});
