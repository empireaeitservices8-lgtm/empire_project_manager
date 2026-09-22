import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double? width;
  final double height;
  final bool isDarkTheme;
  final bool withGlow;
  final BoxFit fit;

  const AppLogo({
    super.key,
    this.width,
    this.height = 40,
    this.isDarkTheme = true,
    this.withGlow = false,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = isDarkTheme
        ? 'assets/images/logo_dark_theme.png'
        : 'assets/images/logo.png';

    Widget image = Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to standard logo.png if variant not loaded
        return Image.asset(
          'assets/images/logo.png',
          width: width,
          height: height,
          fit: fit,
        );
      },
    );

    if (!withGlow) {
      return image;
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00A0B0).withValues(alpha: 0.25),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: image,
    );
  }
}
