import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

const siteNavLinks = ['About', 'News', 'Events', 'Resources', 'Contact'];

/// Top navigation bar: logo, page links and the EN / TH language toggle.
///
/// Below [AppLayout.desktopBreakpoint] the links collapse into a menu button
/// that opens the Scaffold's end drawer (see [SiteNavDrawer]).
class SiteHeader extends StatelessWidget {
  const SiteHeader({
    super.key,
    required this.isEnglish,
    required this.onLanguageChanged,
    this.onNavigate,
  });

  final bool isEnglish;
  final ValueChanged<bool> onLanguageChanged;
  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppLayout.desktopBreakpoint;

    return Container(
      height: isDesktop ? 100 : 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.symmetric(horizontal: AppLayout.sidePadding(width)),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => onNavigate?.call('Home'),
              child: _Logo(showSubtitle: isDesktop || width >= 520),
            ),
          ),
          const Spacer(),
          if (isDesktop) ...[
            for (final link in siteNavLinks) ...[
              _NavLink(label: link, onTap: () => onNavigate?.call(link)),
              if (link != siteNavLinks.last) const SizedBox(width: 40),
            ],
            const SizedBox(width: 40),
          ],
          LanguageToggle(isEnglish: isEnglish, onChanged: onLanguageChanged),
          if (!isDesktop) ...[
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Menu',
              icon: const Icon(Icons.menu, color: AppColors.ink),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Slide-out menu used on narrow screens.
class SiteNavDrawer extends StatelessWidget {
  const SiteNavDrawer({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          children: [
            for (final link in siteNavLinks)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 28),
                title: Text(
                  link,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  onNavigate?.call(link);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.showSubtitle});

  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    const subtitleStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      height: 1.2,
      color: AppColors.ink,
    );
    return Row(
      children: [
        const Text(
          'CCAT',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.ink,
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(width: 14),
          Container(width: 1, height: 30, color: AppColors.border),
          const SizedBox(width: 14),
          const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Creatives for', style: subtitleStyle),
              Text('Climate Action - Thailand', style: subtitleStyle),
            ],
          ),
        ],
      ],
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _hovered ? AppColors.accent : AppColors.ink,
          ),
        ),
      ),
    );
  }
}

/// Pill-shaped EN / TH switch.
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({
    super.key,
    required this.isEnglish,
    required this.onChanged,
  });

  final bool isEnglish;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.toggleBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.toggleBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _option('EN', isEnglish, () => onChanged(true)),
          _option('TH', !isEnglish, () => onChanged(false)),
        ],
      ),
    );
  }

  Widget _option(String text, bool isSelected, VoidCallback onTap) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 50,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.peach : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.ink : const Color(0xFF555658),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
