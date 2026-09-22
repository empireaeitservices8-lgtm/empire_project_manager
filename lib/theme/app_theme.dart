import 'package:flutter/material.dart';

/// Luxury Obsidian & Gold Color Palette
class NGColors {
  NGColors._();

  // Core Golds & Warmth
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF0C040);
  static const Color goldDark = Color(0xFFA67C2E);
  static const Color champagne = Color(0xFFF5D78E);

  // Dark & Neutral Bases
  static const Color obsidian = Color(0xFF0A0A0A);
  static const Color charcoal = Color(0xFF1A1A1A);
  static const Color graphite = Color(0xFF2A2A2A);
  static const Color cardBg = Color(0xFF141414);
  static const Color cardBgElevated = Color(0xFF1E1E1E);
  static const Color inputBg = Color(0xFF1C1C1C);

  // Luxury Accent Accents
  static const Color rose = Color(0xFFB76E79);
  static const Color platinum = Color(0xFFE5E4E2);
  static const Color ruby = Color(0xFF9B1B30);
  static const Color emerald = Color(0xFF046307);
  static const Color sapphire = Color(0xFF0F52BA);
  static const Color bronze = Color(0xFFCD7F32);
  static const Color amber = Color(0xFFFFBF00);

  // Borders & Glows
  static const Color goldBorder = Color(0x33D4AF37);
  static const Color goldBorderGlow = Color(0x66D4AF37);
  static const Color subtleBorder = Color(0x1AFFFFFF);
  static const Color glassSurface = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x22D4AF37);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldLight, gold, goldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient luxuryCardGradient = LinearGradient(
    colors: [Color(0xFF1C1C1E), Color(0xFF121212)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient obsidianGradient = LinearGradient(
    colors: [Color(0xFF141414), Color(0xFF0A0A0A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// Global Application Theme Configuration
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NGColors.obsidian,
      primaryColor: NGColors.gold,
      colorScheme: const ColorScheme.dark(
        primary: NGColors.gold,
        onPrimary: Colors.black,
        secondary: NGColors.goldLight,
        onSecondary: Colors.black,
        surface: NGColors.cardBg,
        onSurface: Colors.white,
        error: NGColors.ruby,
        onError: Colors.white,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: NGColors.obsidian,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: NGColors.gold),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: NGColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: NGColors.goldBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NGColors.gold,
          foregroundColor: Colors.black,
          elevation: 4,
          shadowColor: NGColors.gold.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: NGColors.gold,
          side: const BorderSide(color: NGColors.gold, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NGColors.inputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.35),
          fontSize: 14,
        ),
        labelStyle: TextStyle(
          color: NGColors.gold.withValues(alpha: 0.8),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NGColors.subtleBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NGColors.subtleBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NGColors.gold, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NGColors.ruby, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NGColors.ruby, width: 1.8),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return NGColors.gold;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.black),
        side: const BorderSide(color: NGColors.gold, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: NGColors.gold,
        foregroundColor: Colors.black,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: NGColors.cardBg,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: NGColors.cardBgElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: NGColors.goldBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: NGColors.subtleBorder,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: NGColors.charcoal,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: NGColors.goldBorder),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Custom Glowing Background Orbs Widget
class GlowingOrbsBackground extends StatelessWidget {
  final Widget child;
  const GlowingOrbsBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top-right glowing radial orb
        Positioned(
          top: -80,
          right: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  NGColors.gold.withValues(alpha: 0.18),
                  NGColors.goldLight.withValues(alpha: 0.06),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        // Bottom-left glowing radial orb
        Positioned(
          bottom: -100,
          left: -100,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  NGColors.rose.withValues(alpha: 0.12),
                  NGColors.goldDark.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
