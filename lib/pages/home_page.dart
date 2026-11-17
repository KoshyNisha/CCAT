import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/arrow_link.dart';
import '../widgets/content_width.dart';
import '../widgets/hero_carousel.dart';
import '../widgets/site_footer.dart';
import '../widgets/site_header.dart';

// Placeholder photo cropped from the Figma frame. Replace with the original
// images, or featured images from the WordPress API.
const _placeholderPhoto = AssetImage('assets/images/placeholder_photo.jpg');

const _heroSlides = [
  HeroSlide(
    image: _placeholderPhoto,
    lead: 'Creatives for Climate Action - Thailand (CCAT)',
    body:
        'is a collaborative platform where Southeast Asian creatives come '
        'together to learn, exchange and co-create climate-positive '
        'practices. Through gatherings and resources, CCAT empowers the '
        'region’s cultural sector (artists, designers, producers, '
        'institutions) to take meaningful action toward a just and '
        'ecologically safe future.',
    linkText: 'Powered by Creative Migration.',
  ),
];

class UpdatePost {
  const UpdatePost({
    required this.category,
    required this.date,
    required this.title,
    required this.excerpt,
    required this.image,
  });

  final String category;
  final String date;
  final String title;
  final String excerpt;
  final ImageProvider image;
}

// Sample posts from the design, until /wp-json/wp/v2/posts is wired up.
const _latestUpdates = [
  UpdatePost(
    category: 'Announcement',
    date: 'Feb 12, 2026',
    title: 'CCAT Launches 2026 Southeast Asia Regional Initiative',
    excerpt:
        'Expanding our collaborative network to foster eco-centric creative '
        'practices and regional policy engagement across SEA.',
    image: _placeholderPhoto,
  ),
  UpdatePost(
    category: 'Insights',
    date: 'Jan 28, 2026',
    title: 'Localizing Climate Action in Thai Cultural Institutions',
    excerpt:
        'How Thai art centers and creative hubs are integrating sustainable '
        'operational strategies into their programming.',
    image: _placeholderPhoto,
  ),
  UpdatePost(
    category: 'Community',
    date: 'Jan 15, 2026',
    title: 'Recap: Creative Climate Action Toolkit Workshop',
    excerpt:
        'Highlights and key takeaways from our collaborative workshop with '
        'Bangkok-based creative professionals.',
    image: _placeholderPhoto,
  ),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SiteNavDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            SiteHeader(
              isEnglish: _isEnglish,
              onLanguageChanged: (value) => setState(() => _isEnglish = value),
            ),
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HeroCarousel(slides: _heroSlides),
                    _OurWorkSection(),
                    Divider(height: 1, thickness: 1, color: AppColors.border),
                    _LatestUpdatesSection(),
                    SiteFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isNarrow =
        MediaQuery.sizeOf(context).width < AppLayout.tabletBreakpoint;
    return Text(
      text,
      style: TextStyle(
        fontSize: isNarrow ? 36 : 52,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.1,
        color: AppColors.ink,
      ),
    );
  }
}

class _OurWorkSection extends StatelessWidget {
  const _OurWorkSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppLayout.desktopBreakpoint;
    final isNarrow = width < AppLayout.tabletBreakpoint;

    const linkStyle = TextStyle(
      fontWeight: FontWeight.w700,
      color: AppColors.accent,
    );

    const events = _WorkCard(
      title: 'Events',
      body:
          'We organize interactive sessions, workshops, and gatherings that '
          'bring artists, producers, and cultural workers together to '
          'collaborate on regional climate strategies and lived experiences.',
      linkLabel: 'Explore all events',
      background: AppColors.eventsCard,
      border: AppColors.eventsCardBorder,
    );
    const resources = _WorkCard(
      title: 'Resources',
      body:
          'Explore practical frameworks, open-access action guides, and '
          'sustainability checklists tailored to regional cultural practices.',
      linkLabel: 'Explore library',
      background: AppColors.resourcesCard,
      border: AppColors.resourcesCardBorder,
    );

    return ContentWidth(
      padding: EdgeInsets.symmetric(vertical: isNarrow ? 64 : 112),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading('OUR WORK'),
          const SizedBox(height: 28),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: Container(
              padding: const EdgeInsets.only(left: 24),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppColors.accent, width: 4),
                ),
              ),
              child: Text.rich(
                const TextSpan(
                  text:
                      'CCAT brings people together to build tools that '
                      'remain actionable long after the room empties. '
                      'Browse our ',
                  children: [
                    TextSpan(text: 'interactive events', style: linkStyle),
                    TextSpan(text: ' and explore '),
                    TextSpan(
                      text: 'localized climate action toolkits',
                      style: linkStyle,
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
                style: TextStyle(
                  fontSize: isNarrow ? 17 : 20,
                  height: 1.7,
                  color: AppColors.body,
                ),
              ),
            ),
          ),
          const SizedBox(height: 56),
          if (isDesktop)
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 412),
              child: const IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: events),
                    SizedBox(width: 40),
                    Expanded(child: resources),
                  ],
                ),
              ),
            )
          else
            const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [events, SizedBox(height: 24), resources],
            ),
        ],
      ),
    );
  }
}

class _WorkCard extends StatelessWidget {
  const _WorkCard({
    required this.title,
    required this.body,
    required this.linkLabel,
    required this.background,
    required this.border,
  });

  final String title;
  final String body;
  final String linkLabel;
  final Color background;
  final Color border;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    // Side-by-side cards share a height, so push the link to the bottom.
    final fillsHeight = width >= AppLayout.desktopBreakpoint;
    final isNarrow = width < AppLayout.tabletBreakpoint;

    return Container(
      padding: EdgeInsets.all(isNarrow ? 28 : 56),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isNarrow ? 30 : 40,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              height: 1.2,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: isNarrow ? 20 : 32),
          Text(
            body,
            style: TextStyle(
              fontSize: isNarrow ? 16 : 18,
              height: 1.75,
              color: AppColors.body,
            ),
          ),
          const SizedBox(height: 32),
          if (fillsHeight) const Spacer(),
          const Divider(height: 1, thickness: 1, color: AppColors.cardDivider),
          SizedBox(height: isNarrow ? 28 : 44),
          ArrowLink(label: linkLabel, fontSize: isNarrow ? 18 : 22),
        ],
      ),
    );
  }
}

class _LatestUpdatesSection extends StatelessWidget {
  const _LatestUpdatesSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppLayout.desktopBreakpoint;
    final isNarrow = width < AppLayout.tabletBreakpoint;

    return ContentWidth(
      padding: EdgeInsets.symmetric(vertical: isNarrow ? 64 : 112),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading('LATEST UPDATES'),
          const SizedBox(height: 20),
          Text(
            'Stories, announcements, and insights from our community',
            style: TextStyle(
              fontSize: isNarrow ? 16 : 18,
              color: AppColors.body,
            ),
          ),
          const SizedBox(height: 56),
          if (isDesktop)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (i, post) in _latestUpdates.indexed) ...[
                    if (i > 0) const SizedBox(width: 40),
                    Expanded(child: _UpdateCard(post: post, fillsHeight: true)),
                  ],
                ],
              ),
            )
          else
            Column(
              children: [
                for (final (i, post) in _latestUpdates.indexed) ...[
                  if (i > 0) const SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: _UpdateCard(post: post, fillsHeight: false),
                  ),
                ],
              ],
            ),
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.centerRight,
            child: ArrowLink(
              label: 'Explore all news',
              fontSize: isNarrow ? 18 : 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _UpdateCard extends StatelessWidget {
  const _UpdateCard({required this.post, required this.fillsHeight});

  final UpdatePost post;
  final bool fillsHeight;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 14,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _CategoryTag(post.category),
              Text(
                post.date,
                style: const TextStyle(fontSize: 15, color: AppColors.body),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.36,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            post.excerpt,
            style: const TextStyle(
              fontSize: 16,
              height: 1.7,
              color: AppColors.body,
            ),
          ),
          const SizedBox(height: 40),
          if (fillsHeight) const Spacer(),
          const ArrowLink(label: 'Read article', fontSize: 16),
        ],
      ),
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1.81,
            child: Image(image: post.image, fit: BoxFit.cover),
          ),
          if (fillsHeight) Expanded(child: content) else content,
        ],
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  const _CategoryTag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.peach,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.peachBorder),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: AppColors.ink,
        ),
      ),
    );
  }
}
