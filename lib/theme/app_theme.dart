import 'package:flutter/material.dart';

/// Home page colors from the "Home Page — Light / Crisp Editorial" Figma frame.
/// Text colors match CcatColors so the home page sits in with the other pages.
class AppColors {
  static const ink = Color(0xFF111111); // CcatColors.textPrimary
  static const body = Color(0xFF5F5F5F); // CcatColors.textMuted
  static const accent = Color(0xFFB54428);
  static const peach = Color(0xFFF9D4BF);
  static const peachBorder = Color(0xFFE7B3A1);

  static const eventsCard = Color(0xFFFFF4ED);
  static const eventsCardBorder = Color(0xFFEBDDD4);
  static const resourcesCard = Color(0xFFFFF9ED);
  static const resourcesCardBorder = Color(0xFFE9E2D6);
  static const cardDivider = Color(0xFFF0E2D9);

  static const border = Color(0xFFE6E6E7);

  static const heroLink = Color(0xFFA8B4F7);
  static const heroCounter = Color(0xFF7F8CF8);
}

/// Page layout values shared with the other pages (see EventsPage).
class AppLayout {
  static const maxContentWidth = 1600.0;
  static const desktopBreakpoint = 1080.0;
  static const tabletBreakpoint = 760.0;

  /// Height of the shared SiteHeader.
  static const headerHeight = 72.0;

  static double sidePadding(double width) => width < tabletBreakpoint ? 24 : 56;
}
