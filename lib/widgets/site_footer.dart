import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_theme.dart';
import 'content_width.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key, this.onDonate});

  final VoidCallback? onDonate;

  @override
  Widget build(BuildContext context) {
    final isNarrow =
        MediaQuery.sizeOf(context).width < AppLayout.tabletBreakpoint;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.footer,
        border: Border(top: BorderSide(color: AppColors.footerBorder)),
      ),
      child: Column(
        children: [
          ContentWidth(
            padding: EdgeInsets.only(top: isNarrow ? 48 : 72, bottom: 56),
            child: isNarrow
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FooterInfo(),
                      const SizedBox(height: 32),
                      _DonateButton(onPressed: onDonate),
                    ],
                  )
                : Row(
                    children: [
                      const Expanded(child: _FooterInfo()),
                      const SizedBox(width: 24),
                      _DonateButton(onPressed: onDonate),
                    ],
                  ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.footerBorder),
          ContentWidth(
            padding: const EdgeInsets.only(top: 48, bottom: 56),
            child: Text.rich(
              const TextSpan(
                text:
                    '© 2024–2026, Creative Migration, All rights reserved. '
                    'Site by ',
                children: [
                  TextSpan(
                    text: 'XXX',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
              style: const TextStyle(fontSize: 15, color: AppColors.body),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterInfo extends StatelessWidget {
  const _FooterInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CREATIVES FOR CLIMATE ACTION - THAILAND',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            height: 1.25,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 6),
        const Text.rich(
          TextSpan(
            text: 'A project by ',
            children: [
              TextSpan(
                text: 'Creative Migration',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.ink,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          style: TextStyle(fontSize: 16, color: AppColors.body),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 26,
          children: const [
            _SocialIcon(
              icon: FaIcon(FontAwesomeIcons.instagram),
              label: 'Instagram',
            ),
            _SocialIcon(
              icon: FaIcon(FontAwesomeIcons.linkedinIn),
              label: 'LinkedIn',
            ),
            _SocialIcon(
              icon: FaIcon(FontAwesomeIcons.facebookF),
              label: 'Facebook',
            ),
            _SocialIcon(icon: Icon(Icons.language), label: 'Website'),
          ],
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  const _SocialIcon({required this.icon, required this.label});

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            // TODO: open the social profile once the URLs are known.
          },
          child: SizedBox(
            width: 20,
            height: 20,
            child: Center(
              child: IconTheme.merge(
                data: const IconThemeData(size: 18, color: AppColors.ink),
                child: icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DonateButton extends StatelessWidget {
  const _DonateButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed ?? () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accent,
        side: const BorderSide(color: AppColors.accent, width: 1.5),
        shape: const StadiumBorder(),
        minimumSize: const Size(136, 60),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        textStyle: const TextStyle(
          fontFamily: 'IBM Plex Sans',
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: const Text('Donate'),
    );
  }
}
