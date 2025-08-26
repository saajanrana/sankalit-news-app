import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFFF0000);
  static const Color secondaryColor = Color(0xFF232020);
  static const Color accentColor = Color(0xFFFF6B35);
  static const Color errorColor = Color(0xFFB00020);

  // Light Theme Colors
  static const Color lightBackgroundColor = Color(0xFFFAFAFA);
  static const Color lightSurfaceColor = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF757575);

  // Dark Theme Colors
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);

  // -- bottom bar colors
  static const Color bottomBarDarkColor = Color(0xFF232020);

//   static ThemeData get lightTheme {
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.light,
//       colorScheme: const ColorScheme.light(
//         primary: primaryColor,
//         secondary: secondaryColor,
//         tertiary: accentColor,
//         error: errorColor,
//         background: lightBackgroundColor,
//         surface: lightSurfaceColor,
//         onPrimary: Colors.white,
//         onSecondary: Colors.white,
//         onBackground: lightTextPrimary,
//         onSurface: lightTextPrimary,
//       ),
//       textTheme: _buildTextTheme(lightTextPrimary, lightTextSecondary),
//       appBarTheme: AppBarTheme(
//         elevation: 0,
//         backgroundColor: lightSurfaceColor,
//         foregroundColor: lightTextPrimary,
//         titleTextStyle: GoogleFonts.poppins(
//           fontSize: 18.sp,
//           fontWeight: FontWeight.w600,
//           color: lightTextPrimary,
//         ),
//       ),
//       bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         backgroundColor: lightSurfaceColor,
//         selectedItemColor: primaryColor,
//         unselectedItemColor: lightTextSecondary,
//         type: BottomNavigationBarType.fixed,
//         elevation: 8,
//       ),
//       // cardTheme: CardTheme(
//       //   color: lightSurfaceColor,
//       //   elevation: 2,
//       //   shape: RoundedRectangleBorder(
//       //     borderRadius: BorderRadius.circular(12.r),
//       //   ),
//       // ),
//     );
//   }

//   static ThemeData get darkTheme {
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.dark,

//       colorScheme: const ColorScheme.dark(
//         primary: primaryColor,
//         secondary: secondaryColor,
//         tertiary: accentColor,
//         error: errorColor,
//         background: darkBackgroundColor,
//         surface: darkSurfaceColor,
//         onPrimary: Colors.white,
//         onSecondary: Colors.white,
//         onBackground: darkTextPrimary,
//         onSurface: darkTextPrimary,
//       ),
//       textTheme: _buildTextTheme(darkTextPrimary, darkTextSecondary),
//       appBarTheme: AppBarTheme(
//         elevation: 0,
//         backgroundColor: darkSurfaceColor,
//         foregroundColor: darkTextPrimary,
//         titleTextStyle: GoogleFonts.poppins(
//           fontSize: 18.sp,
//           fontWeight: FontWeight.w600,
//           color: darkTextPrimary,
//         ),
//       ),
//       bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         backgroundColor: darkSurfaceColor,
//         selectedItemColor: primaryColor,
//         unselectedItemColor: darkTextSecondary,
//         type: BottomNavigationBarType.fixed,
//         elevation: 8,
//       ),
//       // cardTheme: CardTheme(
//       //   color: darkSurfaceColor,
//       //   elevation: 2,
//       //   shape: RoundedRectangleBorder(
//       //     borderRadius: BorderRadius.circular(12.r),
//       //   ),
//       // ),
//     );
//   }

//   static TextTheme _buildTextTheme(Color primaryColor, Color secondaryColor) {
//     return TextTheme(
//       displayLarge: GoogleFonts.poppins(
//         fontSize: 32.sp,
//         fontWeight: FontWeight.bold,
//         color: primaryColor,
//       ),
//       displayMedium: GoogleFonts.poppins(
//         fontSize: 28.sp,
//         fontWeight: FontWeight.bold,
//         color: primaryColor,
//       ),
//       displaySmall: GoogleFonts.poppins(
//         fontSize: 24.sp,
//         fontWeight: FontWeight.w600,
//         color: primaryColor,
//       ),
//       headlineLarge: GoogleFonts.poppins(
//         fontSize: 20.sp,
//         fontWeight: FontWeight.w600,
//         color: primaryColor,
//       ),
//       headlineMedium: GoogleFonts.poppins(
//         fontSize: 18.sp,
//         fontWeight: FontWeight.w600,
//         color: primaryColor,
//       ),
//       headlineSmall: GoogleFonts.poppins(
//         fontSize: 16.sp,
//         fontWeight: FontWeight.w500,
//         color: primaryColor,
//       ),
//       titleLarge: GoogleFonts.inter(
//         fontSize: 18.sp,
//         fontWeight: FontWeight.w500,
//         color: primaryColor,
//       ),
//       titleMedium: GoogleFonts.inter(
//         fontSize: 16.sp,
//         fontWeight: FontWeight.w500,
//         color: primaryColor,
//       ),
//       titleSmall: GoogleFonts.inter(
//         fontSize: 14.sp,
//         fontWeight: FontWeight.w500,
//         color: primaryColor,
//       ),
//       bodyLarge: GoogleFonts.inter(
//         fontSize: 16.sp,
//         fontWeight: FontWeight.normal,
//         color: primaryColor,
//       ),
//       bodyMedium: GoogleFonts.inter(
//         fontSize: 14.sp,
//         fontWeight: FontWeight.normal,
//         color: primaryColor,
//       ),
//       bodySmall: GoogleFonts.inter(
//         fontSize: 12.sp,
//         fontWeight: FontWeight.normal,
//         color: secondaryColor,
//       ),
//       labelLarge: GoogleFonts.inter(
//         fontSize: 14.sp,
//         fontWeight: FontWeight.w500,
//         color: primaryColor,
//       ),
//       labelMedium: GoogleFonts.inter(
//         fontSize: 12.sp,
//         fontWeight: FontWeight.w500,
//         color: secondaryColor,
//       ),
//       labelSmall: GoogleFonts.inter(
//         fontSize: 10.sp,
//         fontWeight: FontWeight.w500,
//         color: secondaryColor,
//       ),
//     );
//   }
}
