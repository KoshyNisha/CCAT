import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Red "Label →" call-to-action link used throughout the site.
class ArrowLink extends StatefulWidget {
  const ArrowLink({
    super.key,
    required this.label,
    this.onTap,
    this.fontSize = 18,
  });

  final String label;
  final VoidCallback? onTap;
  final double fontSize;

  @override
  State<ArrowLink> createState() => _ArrowLinkState();
}

class _ArrowLinkState extends State<ArrowLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                  decoration: _hovered ? TextDecoration.underline : null,
                  decorationColor: AppColors.accent,
                ),
              ),
            ),
            SizedBox(width: widget.fontSize * 0.3),
            AnimatedSlide(
              offset: _hovered ? const Offset(0.25, 0) : Offset.zero,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              child: Icon(
                Icons.arrow_forward,
                size: widget.fontSize,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
