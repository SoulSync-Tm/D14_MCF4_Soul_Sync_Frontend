import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Constants
  static const Color backgroundColor = Color(0xFF121212); // Dark Grey
  static const Color primaryColor = Color(0xFF8A2BE2); // SoulSync Violet
  static const Color surfaceColor = Color(0xFF1E1E1E);
  static const Color textColor = Colors.white;

  // Glass Decoration
  static const BoxDecoration glassDecoration = BoxDecoration(
    color: Color.fromRGBO(255, 255, 255, 0.1), // White with 0.1 opacity
    borderRadius: BorderRadius.all(Radius.circular(16)),
    border: Border.fromBorderSide(
      BorderSide(
        color: Color.fromRGBO(255, 255, 255, 0.2),
        width: 1,
      ),
    ),
  );

  // Theme Data
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: primaryColor,
        colorScheme: const ColorScheme.dark(
          primary: primaryColor,
          secondary: primaryColor,
          surface: surfaceColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: textColor,
          background: backgroundColor,
          onBackground: textColor,
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme.copyWith(
                displayLarge: GoogleFonts.inter(color: textColor),
                displayMedium: GoogleFonts.inter(color: textColor),
                displaySmall: GoogleFonts.inter(color: textColor),
                headlineLarge: GoogleFonts.inter(color: textColor),
                headlineMedium: GoogleFonts.inter(color: textColor),
                headlineSmall: GoogleFonts.inter(color: textColor),
                titleLarge: GoogleFonts.inter(color: textColor),
                titleMedium: GoogleFonts.inter(color: textColor),
                titleSmall: GoogleFonts.inter(color: textColor),
                bodyLarge: GoogleFonts.inter(color: textColor),
                bodyMedium: GoogleFonts.inter(color: textColor),
                bodySmall: GoogleFonts.inter(color: textColor),
                labelLarge: GoogleFonts.inter(color: textColor),
                labelMedium: GoogleFonts.inter(color: textColor),
                labelSmall: GoogleFonts.inter(color: textColor),
              ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: GoogleFonts.inter(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: const CardThemeData(
          color: surfaceColor,
          elevation: 8,
          margin: EdgeInsets.all(8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.black.withOpacity(0.9),
          indicatorColor: primaryColor.withOpacity(0.2),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.inter(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              );
            }
            return GoogleFonts.inter(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            );
          }),
        ),
      );
}