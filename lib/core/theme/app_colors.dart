import 'package:flutter/material.dart';

/// Centralized color palette for the Al-Quran app.
/// Islamic modern minimalist: emerald green + gold accent.
class AppColors {
  AppColors._();

  // ── Primary Palette ──
  static const Color primary = Color(0xFF1B7A4A);
  static const Color primaryLight = Color(0xFF2E9B63);
  static const Color primaryDark = Color(0xFF145A37);
  static const Color primarySurface = Color(0xFFE8F5EC);

  // ── Accent / Gold ──
  static const Color accent = Color(0xFFD4A835);
  static const Color accentLight = Color(0xFFE8C860);
  static const Color accentDark = Color(0xFFB08C20);

  // ── Neutrals ──
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE8ECF0);
  static const Color divider = Color(0xFFE0E4E8);
  static const Color textPrimary = Color(0xFF1A1D21);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color iconDefault = Color(0xFF6B7280);

  // ── Dark Mode ──
  static const Color darkBackground = Color(0xFF0F1419);
  static const Color darkSurface = Color(0xFF1A2028);
  static const Color darkCard = Color(0xFF222A35);
  static const Color darkCardBorder = Color(0xFF2D3748);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // ── Semantic ──
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ── Tajwid Colors ──
  static const Color tajwidIdghamBighunnah = Color(0xFF2563EB);
  static const Color tajwidIdghamBilaaghunnah = Color(0xFF7C3AED);
  static const Color tajwidIkhfa = Color(0xFFEA580C);
  static const Color tajwidIqlab = Color(0xFF0891B2);
  static const Color tajwidIzhar = Color(0xFF059669);
  static const Color tajwidGhunnah = Color(0xFF16A34A);
  static const Color tajwidQalqalah = Color(0xFF2563EB);
  static const Color tajwidMad = Color(0xFFDC2626);
  static const Color tajwidIkhfaSyafawi = Color(0xFFDB2777);
  static const Color tajwidIdghamMimi = Color(0xFF9333EA);

  // ── Gradients ──
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B7A4A), Color(0xFF2E9B63)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF145A37), Color(0xFF1B7A4A), Color(0xFF2E9B63)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD4A835), Color(0xFFE8C860)],
  );

  static const LinearGradient darkHeaderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F2E1D), Color(0xFF1A4A33)],
  );
}
