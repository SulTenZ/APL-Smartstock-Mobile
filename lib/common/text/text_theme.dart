// common/text/text_theme.dart
// Pengaturan TextTheme menggunakan Google Fonts agar mudah digunakan kembali di seluruh aplikasi.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  // Ganti 'Poppins' dengan font Google Font pilihan Anda.
  static TextTheme get defaultTextTheme => TextTheme(
    // Headline besar
    displayLarge: GoogleFonts.poppins(
      fontSize: 96,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 60,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 48,
      fontWeight: FontWeight.normal,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 34,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.normal,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    // Subtitle
    titleMedium: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.15,
    ),
    titleSmall: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    // Body
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.5,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
    ),
    // Button
    labelLarge: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
    ),
    // Caption
    bodySmall: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.4,
    ),
    // Overline
    labelSmall: GoogleFonts.poppins(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      letterSpacing: 1.5,
    ),
  );
}
