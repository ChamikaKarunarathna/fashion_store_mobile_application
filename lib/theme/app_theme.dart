import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryGreen = Color(0xFF27AE60); // Assuming standard green from design
  static const Color backgroundWhite = Colors.white;
  static const Color textDark = Color(0xFF333333);
  static const Color textGrey = Color(0xFF828282);
  static const Color textLightGrey = Color(0xFFBDBDBD);
  static const Color borderGrey = Color(0xFFE0E0E0);
  
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: backgroundWhite,
      primaryColor: primaryGreen,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(color: textDark, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.inter(color: textDark, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.inter(color: textDark, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.inter(color: textDark, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.inter(color: textDark, fontWeight: FontWeight.w600),
        titleSmall: GoogleFonts.inter(color: textDark, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.inter(color: textDark),
        bodyMedium: GoogleFonts.inter(color: textGrey),
        labelLarge: GoogleFonts.inter(color: primaryGreen, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        hintStyle: GoogleFonts.inter(color: textLightGrey),
        labelStyle: GoogleFonts.inter(color: textDark, fontWeight: FontWeight.w600),
      ),
    );
  }
}
