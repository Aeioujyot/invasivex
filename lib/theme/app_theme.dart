import 'package:flutter/material.dart';

import '../models/threat_level.dart';

/// InvasiveX's ecological color system: dark canopy green, light sage green,
/// and cream, with a warm rust/amber reserved for invasive-species alerts.
class AppColors {
  AppColors._();

  // Core palette (light mode values).
  static const canopy = Color(0xFF113C24);
  static const forest = Color(0xFF2B6A4F);
  static const sage = Color(0xFF95D5B2);
  static const mint = Color(0xFFE2F2E7);
  static const cream = Color(0xFFFAF5E7);
  static const parchment = Color(0xFFF5EEDB);
  static const rust = Color(0xFFB85A18);
  static const clay = Color(0xFFF5E1CA);
  static const ink = Color(0xFF212713);
  static const inkMuted = Color(0xFF5C684D);

  // Dark mode variants.
  static const canopyDark = Color(0xFF0E1C13);
  static const forestDark = Color(0xFF4A8A6B);
  static const sageDark = Color(0xFF4E7462);
  static const mintDark = Color(0xFF212E27);
  static const creamDark = Color(0xFF191C18);
  static const parchmentDark = Color(0xFF242822);
  static const rustDark = Color(0xFFDB7F34);
  static const clayDark = Color(0xFF382819);
  static const inkDark = Color(0xFFEAEEE6);
  static const inkMutedDark = Color(0xFFB0B8A9);

  static Color threatColor(ThreatLevel level, {required bool isDark}) {
    switch (level) {
      case ThreatLevel.low:
        return isDark ? forestDark : forest;
      case ThreatLevel.moderate:
        return isDark ? const Color(0xFFC8B84E) : const Color(0xFF9F9225);
      case ThreatLevel.high:
        return isDark ? rustDark : rust;
      case ThreatLevel.severe:
        return isDark ? const Color(0xFFD4553C) : const Color(0xFF9B301B);
      case ThreatLevel.unknown:
        return isDark ? inkMutedDark : inkMuted;
    }
  }
}

/// Semantic color roles, resolved per-brightness so widgets never hardcode
/// a light/dark choice themselves.
extension AppColorScheme on ColorScheme {
  bool get _isDark => brightness == Brightness.dark;

  Color get background => _isDark ? AppColors.creamDark : AppColors.cream;
  Color get surface2 => _isDark ? AppColors.parchmentDark : AppColors.parchment;
  Color get surfaceAlt => _isDark ? AppColors.mintDark : AppColors.mint;
  Color get primaryText => _isDark ? AppColors.inkDark : AppColors.ink;
  Color get secondaryText => _isDark ? AppColors.inkMutedDark : AppColors.inkMuted;
  Color get accent => _isDark ? AppColors.forestDark : AppColors.forest;
  Color get accentStrong => _isDark ? AppColors.sage : AppColors.canopy;
  Color get warning => _isDark ? AppColors.rustDark : AppColors.rust;
  Color get warningFill => _isDark ? AppColors.clayDark : AppColors.clay;
  Color get sageTint => _isDark ? AppColors.sageDark : AppColors.sage;
}

class AppTheme {
  AppTheme._();

  static ThemeData light = _build(Brightness.light);
  static ThemeData dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: isDark ? AppColors.sage : AppColors.canopy,
      onPrimary: isDark ? AppColors.canopyDark : Colors.white,
      secondary: isDark ? AppColors.forestDark : AppColors.forest,
      onSecondary: Colors.white,
      error: isDark ? AppColors.rustDark : AppColors.rust,
      onError: Colors.white,
      surface: isDark ? AppColors.parchmentDark : AppColors.parchment,
      onSurface: isDark ? AppColors.inkDark : AppColors.ink,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? AppColors.creamDark : AppColors.cream,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.creamDark : AppColors.cream,
        foregroundColor: isDark ? AppColors.inkDark : AppColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: isDark ? AppColors.inkDark : AppColors.ink,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.parchmentDark : AppColors.parchment,
        indicatorColor: (isDark ? AppColors.sageDark : AppColors.sage).withValues(alpha: 0.55),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.inkDark : AppColors.ink),
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.parchmentDark : AppColors.parchment,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: scheme.accent.withValues(alpha: 0.12)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: isDark ? AppColors.forestDark : AppColors.canopy,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? AppColors.sage : AppColors.forest,
          side: BorderSide(color: (isDark ? AppColors.sage : AppColors.forest).withValues(alpha: 0.6)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.mintDark : AppColors.mint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      fontFamily: 'Georgia',
    );
  }
}
