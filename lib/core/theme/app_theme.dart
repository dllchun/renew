import 'package:flutter/material.dart';

class AppTheme {
  // Base Colors
  static const Color primaryColor = Color(0xFF7EC8B1); // Soft sage green
  static const Color accentColor = Color(0xFFA8D5BA); // Light mint
  static const Color backgroundColor = Color(0xFFF1F7F0); // Soft mint white
  static const Color surfaceColor = Color(0xFFE8F3EC); // Lighter mint
  static const Color cardColor = Color(0xFFFFFFFF); // Pure white for cards

  // Text Colors
  static const Color textPrimaryColor = Color(0xFF2C4C3B); // Deep forest green
  static const Color textSecondaryColor = Color(0xFF5C7D6F); // Muted sage

  // Status Colors
  static const Color successColor = Color(0xFF7EC8B1); // Soft sage
  static const Color errorColor = Color(0xFFE88B84); // Soft coral
  static const Color warningColor = Color(0xFFE6C674); // Muted gold
  static const Color energyColor = Color(0xFF8ECAE6); // Soft sky blue
  static const Color xpColor = Color(0xFFDBA159); // Warm bronze

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7EC8B1), // Soft sage
      Color(0xFFA8D5BA), // Light mint
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF8FBF9),
    ],
  );

  // Get the theme data
  static ThemeData get darkTheme {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light().copyWith(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
      ),
      textTheme: const TextTheme().copyWith(
        bodyLarge: const TextStyle(color: textPrimaryColor),
        bodyMedium: const TextStyle(color: textPrimaryColor),
        titleLarge: const TextStyle(color: textPrimaryColor),
        titleMedium: const TextStyle(color: textPrimaryColor),
        titleSmall: const TextStyle(color: textPrimaryColor),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        indicatorColor: primaryColor.withOpacity(0.15),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(color: textPrimaryColor, fontWeight: FontWeight.w500),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  // Game-specific styles
  static BoxDecoration get questCardDecoration => BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get achievementCardDecoration => BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get progressBarDecoration => BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withOpacity(0.1),
          width: 1,
        ),
      );
}
