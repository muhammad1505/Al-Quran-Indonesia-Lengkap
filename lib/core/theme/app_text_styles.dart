import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Pre-built text styles for the Al-Quran app.
class AppTextStyles {
  AppTextStyles._();

  // ── Headings ──
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ── Body ──
  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  // ── Labels ──
  static TextStyle label = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: AppColors.textSecondary,
  );

  static TextStyle labelSmall = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    color: AppColors.textTertiary,
  );

  // ── Arabic Text ──
  static TextStyle arabicLarge = GoogleFonts.amiri(
    fontSize: 28,
    height: 2.0,
    color: AppColors.textPrimary,
  );

  static TextStyle arabicMedium = GoogleFonts.amiri(
    fontSize: 22,
    height: 1.8,
    color: AppColors.textPrimary,
  );

  static TextStyle arabicSmall = GoogleFonts.amiri(
    fontSize: 18,
    height: 1.8,
    color: AppColors.textPrimary,
  );

  // ── Special ──
  static TextStyle surahNumber = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle counterDisplay = GoogleFonts.poppins(
    fontSize: 96,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static TextStyle prayerTime = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle prayerName = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
}
