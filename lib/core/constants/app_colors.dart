import 'package:flutter/material.dart';

/// Design language modelled on "Gym Workout App & Fitness Plan"
/// (Fitness Online): teal accent + deep-navy feature cards, in both a light
/// and a dark palette. `AppColors.isDark` is flipped by the theme provider;
/// every member is a getter so the whole app re-skins on theme change.
class AppColors {
  AppColors._();

  /// Toggled by the theme provider before the app rebuilds.
  static bool isDark = false;

  // ── Backgrounds ────────────────────────────────────────────────────────────
  static Color get background => isDark ? const Color(0xFF0E1B25) : const Color(0xFFF5F7F9);
  static Color get surface => isDark ? const Color(0xFF162835) : const Color(0xFFFFFFFF);
  static Color get surfaceElevated => isDark ? const Color(0xFF1F3546) : const Color(0xFFEDF1F4);
  static Color get card => surface;

  // Deep navy — feature cards, selected pills (signature of the reference app)
  static Color get navy => isDark ? const Color(0xFF1C3B54) : const Color(0xFF14384F);
  static Color get navyDark => isDark ? const Color(0xFF12283A) : const Color(0xFF0D2A3C);

  // ── Primary accent — teal ──────────────────────────────────────────────────
  static Color get primary => const Color(0xFF26B8C4);
  static Color get primaryDark => const Color(0xFF1B9AA6);
  static Color get primaryContainer => isDark ? const Color(0xFF123C44) : const Color(0xFFDFF4F6);

  // ── Text ───────────────────────────────────────────────────────────────────
  static Color get textPrimary => isDark ? const Color(0xFFF2F6F8) : const Color(0xFF10293A);
  static Color get textSecondary => isDark ? const Color(0xFF93A6B2) : const Color(0xFF6B7A86);
  static Color get textTertiary => isDark ? const Color(0xFF647987) : const Color(0xFF9AA7B0);
  static Color get textInverse => isDark ? const Color(0xFF0E1B25) : const Color(0xFFFFFFFF);

  // ── Semantic ───────────────────────────────────────────────────────────────
  static Color get success => const Color(0xFF2FBF71);
  static Color get error => const Color(0xFFE5484D);
  static Color get warning => const Color(0xFFF5A623);
  static Color get info => const Color(0xFF2680EB);

  // ── Workout status ─────────────────────────────────────────────────────────
  static Color get completed => primary;
  static Color get missed => error;
  static Color get restDay => isDark ? const Color(0xFF24384A) : const Color(0xFFE2E8ED);
  static Color get today => primary;

  // ── PR badge ───────────────────────────────────────────────────────────────
  static Color get prGold => isDark ? const Color(0xFFF5C542) : const Color(0xFFE8A400);
  static Color get prGoldDark => isDark ? const Color(0xFFDCA92E) : const Color(0xFFC98A00);

  // ── Chart ──────────────────────────────────────────────────────────────────
  static Color get chartLine => primary;
  static Color get chartFill => const Color(0x2926B8C4);
  static Color get chartGrid => isDark ? const Color(0xFF24384A) : const Color(0xFFE5EBEF);

  // ── Divider / overlay ─────────────────────────────────────────────────────
  static Color get divider => isDark ? const Color(0xFF24384A) : const Color(0xFFE2E8ED);
  static Color get overlay => const Color(0x66000000);

  // Fixed-tone helpers used on navy cards (same in both themes).
  static const Color onNavySecondary = Color(0xFFB8C7D1);
}
