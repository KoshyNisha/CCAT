import 'package:flutter/material.dart';

/// Colors sampled from the "Home Page — Light / Crisp Editorial" Figma frame.
class AppColors {
  static const ink = Color(0xFF101114);
  static const body = Color(0xFF57585A);
  static const accent = Color(0xFFB54428);
  static const peach = Color(0xFFF9D4BF);
  static const peachBorder = Color(0xFFE7B3A1);

  static const eventsCard = Color(0xFFFFF4ED);
  static const eventsCardBorder = Color(0xFFEBDDD4);
  static const resourcesCard = Color(0xFFFFF9ED);
  static const resourcesCardBorder = Color(0xFFE9E2D6);
  static const cardDivider = Color(0xFFF0E2D9);

  static const border = Color(0xFFE6E6E7);
  static const toggleBackground = Color(0xFFF6F6F6);
  static const toggleBorder = Color(0xFFDDDDDD);

  static const footer = Color(0xFFFFF9F5);
  static const footerBorder = Color(0xFFF0EAE7);

  static const heroLink = Color(0xFFA8B4F7);
  static const heroCounter = Color(0xFF7F8CF8);
}

/// Shared layout values. The design is 1440 wide with 40px side margins.
class AppLayout {
  static const maxContentWidth = 1440.0;
  static const desktopBreakpoint = 1080.0;
  static const tabletBreakpoint = 640.0;

  static double sidePadding(double width) => width < tabletBreakpoint ? 20 : 40;
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'IBM Plex Sans',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      primary: AppColors.accent,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    ),
  );
}
