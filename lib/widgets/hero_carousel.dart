import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'content_width.dart';

class HeroSlide {
  const HeroSlide({
    required this.image,
    required this.lead,
    required this.body,
    this.linkText,
  });

  final ImageProvider image;

  /// Bold opening words of the caption.
  final String lead;
  final String body;

  /// Optional italic link shown after [body].
  final String? linkText;
}

/// Full-bleed photo banner with a caption and previous/next controls.
class HeroCarousel extends StatefulWidget {
  const HeroCarousel({super.key, required this.slides});

  /// Must not be empty.
  final List<HeroSlide> slides;

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  int _index = 0;

  void _go(int delta) {
    final count = widget.slides.length;
    setState(() => _index = (_index + delta + count) % count);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppLayout.desktopBreakpoint;
    final isNarrow = size.width < AppLayout.tabletBreakpoint;
    final slide = widget.slides[_index];
    // The design fills the first screen below the site header.
    final minHeight = (size.height - AppLayout.headerHeight).clamp(
      480.0,
      904.0,
    );

    // Align so the max width still applies inside the Row's Expanded.
    final caption = Align(
      alignment: Alignment.bottomLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text.rich(
            key: ValueKey(_index),
            TextSpan(
              children: [
                TextSpan(
                  text: slide.lead,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: ' ${slide.body}'),
                if (slide.linkText != null) ...[
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: slide.linkText,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: AppColors.heroLink,
                    ),
                  ),
                ],
              ],
            ),
            style: TextStyle(
              fontSize: isDesktop ? 30 : (isNarrow ? 19 : 24),
              fontWeight: FontWeight.w500,
              height: 1.55,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    final controls = _HeroControls(
      index: _index,
      count: widget.slides.length,
      onPrevious: () => _go(-1),
      onNext: () => _go(1),
    );

    const topPadding = 48.0;
    final bottomPadding = isNarrow ? 40.0 : 96.0;

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Image(
              key: ValueKey(_index),
              image: slide.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        // Darken the photo, more on the left where the caption sits.
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withValues(alpha: 0.72),
                  Colors.black.withValues(alpha: 0.45),
                ],
              ),
            ),
          ),
        ),
        // Non-positioned, so the caption sets the height when it is taller
        // than the minimum (long text on small screens).
        ContentWidth(
          padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: minHeight - topPadding - bottomPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNarrow) ...[
                  caption,
                  const SizedBox(height: 28),
                  controls,
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: caption),
                      const SizedBox(width: 40),
                      controls,
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroControls extends StatelessWidget {
  const _HeroControls({
    required this.index,
    required this.count,
    required this.onPrevious,
    required this.onNext,
  });

  final int index;
  final int count;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${twoDigits(index + 1)} / ${twoDigits(count)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: AppColors.heroCounter,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CircleArrow(
              icon: Icons.arrow_back,
              tooltip: 'Previous slide',
              onPressed: count > 1 ? onPrevious : null,
            ),
            const SizedBox(width: 16),
            _CircleArrow(
              icon: Icons.arrow_forward,
              tooltip: 'Next slide',
              onPressed: count > 1 ? onNext : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _CircleArrow extends StatelessWidget {
  const _CircleArrow({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: CircleBorder(
          side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: 56,
            height: 56,
            child: Center(child: Icon(icon, size: 20, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
