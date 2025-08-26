import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_storage_service.dart';

// Theme state provider
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(LocalStorageService.getThemeMode());

  void toggleTheme() {
    state = !state;
    LocalStorageService.setThemeMode(state);
  }

  void setTheme(bool isDarkMode) {
    state = isDarkMode;
    LocalStorageService.setThemeMode(state);
  }
}