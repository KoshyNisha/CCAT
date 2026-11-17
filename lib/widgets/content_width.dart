import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Centers [child] within [AppLayout.maxContentWidth] and applies the page's
/// side margins, plus any extra vertical [padding].
class ContentWidth extends StatelessWidget {
  const ContentWidth({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final side = AppLayout.sidePadding(MediaQuery.sizeOf(context).width);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
        child: Container(
          width: double.infinity,
          padding: padding + EdgeInsets.symmetric(horizontal: side),
          child: child,
        ),
      ),
    );
  }
}
