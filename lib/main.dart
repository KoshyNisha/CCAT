import 'package:flutter/material.dart';
import 'events_page.dart';

void main() {
  runApp(const CcatApp());
}

class CcatApp extends StatelessWidget {
  const CcatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CCAT | Resources',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: CcatColors.background,
        colorScheme: const ColorScheme.light(
          primary: CcatColors.gold,
          surface: CcatColors.surface,
        ),
        useMaterial3: true,
      ),
      // home: const ResourcesPage(),
      home: const EventsPage(),
    );
  }
}

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  ResourceFilter _selectedFilter = ResourceFilter.all;
  bool _isEnglish = true;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 760;
    final publications = resourceItems
        .where(
          (item) =>
              item.type == ResourceType.publication &&
              (_selectedFilter == ResourceFilter.all ||
                  _selectedFilter == ResourceFilter.publications),
        )
        .toList();
    final recordings = resourceItems
        .where(
          (item) =>
              item.type == ResourceType.recording &&
              (_selectedFilter == ResourceFilter.all ||
                  _selectedFilter == ResourceFilter.recordings),
        )
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SiteHeader(
              isEnglish: _isEnglish,
              onLanguageSelected: (isEnglish) {
                setState(() => _isEnglish = isEnglish);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1600),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            isNarrow ? 24 : 56,
                            isNarrow ? 64 : 96,
                            isNarrow ? 24 : 56,
                            0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const PageIntroduction(),
                              const SizedBox(height: 34),
                              ResourceFilters(
                                selected: _selectedFilter,
                                onSelected: (filter) {
                                  setState(() => _selectedFilter = filter);
                                },
                              ),
                              if (publications.isNotEmpty) ...[
                                const SizedBox(height: 78),
                                const SectionTitle('Publications & Toolkits'),
                                const SizedBox(height: 28),
                                ResourceGrid(
                                  items: publications,
                                  narrow: isNarrow,
                                ),
                              ],
                              if (recordings.isNotEmpty) ...[
                                SizedBox(
                                  height: publications.isEmpty ? 78 : 92,
                                ),
                                const SectionTitle(
                                  'Session Recordings & Discussions',
                                ),
                                const SizedBox(height: 28),
                                ResourceGrid(
                                  items: recordings,
                                  narrow: isNarrow,
                                ),
                              ],
                              const SizedBox(height: 112),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SiteFooter(),
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

class SiteHeader extends StatelessWidget {
  const SiteHeader({
    required this.isEnglish,
    required this.onLanguageSelected,
    super.key,
  });

  final bool isEnglish;
  final ValueChanged<bool> onLanguageSelected;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 900;

    return Container(
      height: 72,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: CcatColors.border)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: narrow ? 24 : 56),
        child: Row(
          children: [
            const Text(
              'CCAT',
              style: TextStyle(
                color: CcatColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.3,
              ),
            ),
            const SizedBox(width: 18),
            Container(width: 1, height: 20, color: CcatColors.border),
            const SizedBox(width: 18),
            if (!narrow)
              const Text(
                'Creatives for Climate Action — Thailand',
                style: TextStyle(
                  color: CcatColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            const Spacer(),
            if (!narrow) const DesktopNavigation(),
            if (narrow)
              const Icon(Icons.menu_rounded, color: CcatColors.textPrimary),
            const SizedBox(width: 18),
            LanguageToggle(
              isEnglish: isEnglish,
              onLanguageSelected: onLanguageSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopNavigation extends StatelessWidget {
  const DesktopNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    const entries = ['About', 'News', 'Events', 'Resources', 'Contact'];

    return Row(
      children: [
        for (final entry in entries)
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              entry,
              style: TextStyle(
                color: entry == 'Resources'
                    ? CcatColors.green
                    : CcatColors.textMuted,
                fontSize: 14,
                fontWeight: entry == 'Resources'
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({
    required this.isEnglish,
    required this.onLanguageSelected,
    super.key,
  });

  final bool isEnglish;
  final ValueChanged<bool> onLanguageSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: CcatColors.border),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LanguageOption(
            label: 'EN',
            selected: isEnglish,
            onTap: () => onLanguageSelected(true),
          ),
          _LanguageOption(
            label: 'TH',
            selected: !isEnglish,
            onTap: () => onLanguageSelected(false),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? CcatColors.textPrimary : CcatColors.textMuted,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class PageIntroduction extends StatelessWidget {
  const PageIntroduction({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CCAT / OPEN LIBRARY',
          style: TextStyle(
            color: CcatColors.green,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.1,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Resources & Knowledge Hub',
          style: TextStyle(
            color: CcatColors.textPrimary,
            fontSize: 48,
            height: 1.05,
            fontWeight: FontWeight.w400,
            letterSpacing: -2.2,
          ),
        ),
        SizedBox(height: 24),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 720),
          child: Text(
            'Explore practical toolkits, field manuals, green guides, and '
            'recorded sessions designed to support climate action across '
            'Thailand’s creative economy.',
            style: TextStyle(
              color: CcatColors.textMuted,
              fontSize: 17,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

class ResourceFilters extends StatelessWidget {
  const ResourceFilters({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final ResourceFilter selected;
  final ValueChanged<ResourceFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: ResourceFilter.values
          .map(
            (filter) => FilterChip(
              label: Text(filter.label),
              selected: selected == filter,
              onSelected: (_) => onSelected(filter),
              showCheckmark: false,
              side: BorderSide(color: filter.accent),
              backgroundColor: Colors.transparent,
              selectedColor: CcatColors.selectedChip,
              labelStyle: TextStyle(
                color: selected == filter
                    ? CcatColors.textPrimary
                    : filter.accent,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
          )
          .toList(),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: CcatColors.textPrimary,
        fontSize: 30,
        fontWeight: FontWeight.w400,
        letterSpacing: -1.1,
      ),
    );
  }
}

class ResourceGrid extends StatelessWidget {
  const ResourceGrid({required this.items, required this.narrow, super.key});

  final List<ResourceItem> items;
  final bool narrow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = narrow ? 1 : 2;
        final cardWidth = (constraints.maxWidth - (columns - 1) * 22) / columns;

        return Wrap(
          spacing: 22,
          runSpacing: 22,
          children: [
            for (final item in items)
              SizedBox(
                width: cardWidth,
                child: ResourceCard(item: item),
              ),
          ],
        );
      },
    );
  }
}

class ResourceCard extends StatelessWidget {
  const ResourceCard({required this.item, super.key});

  final ResourceItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: CcatColors.surface,
        border: Border.all(color: CcatColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: item.type == ResourceType.recording ? 194 : 248,
            child: ResourceVisual(item: item),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.eyebrow,
                  style: TextStyle(
                    color: item.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .5,
                  ),
                ),
                const SizedBox(height: 13),
                Text(
                  item.title,
                  style: const TextStyle(
                    color: CcatColors.textPrimary,
                    fontSize: 22,
                    height: 1.16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -.8,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.description,
                  style: const TextStyle(
                    color: CcatColors.textMuted,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 28),
                if (item.type == ResourceType.publication) ...[
                  Text(
                    item.date!,
                    style: const TextStyle(
                      color: CcatColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 13),
                ],
                if (item.type == ResourceType.publication)
                  PublicationActions(item: item)
                else
                  RecordingAction(item: item),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResourceVisual extends StatelessWidget {
  const ResourceVisual({required this.item, super.key});

  final ResourceItem item;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [item.accent.withValues(alpha: .95), CcatColors.visualShade],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                color: CcatColors.textPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                child: Text(
                  item.visualLabel,
                  style: const TextStyle(
                    color: CcatColors.background,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .7,
                  ),
                ),
              ),
            ),
            if (item.type == ResourceType.recording)
              const Center(
                child: CircleAvatar(
                  radius: 27,
                  backgroundColor: CcatColors.coral,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: CcatColors.background,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PublicationActions extends StatelessWidget {
  const PublicationActions({required this.item, super.key});

  final ResourceItem item;

  @override
  Widget build(BuildContext context) {
    if (item.comingSoon) {
      return OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          disabledForegroundColor: CcatColors.cyan,
          side: const BorderSide(color: CcatColors.cyan),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        ),
        child: const Text('Coming Soon (Oct 2026)'),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        DownloadButton(label: 'English PDF', accent: item.accent),
        DownloadButton(label: 'Thai PDF', accent: item.accent, outlined: true),
      ],
    );
  }
}

class DownloadButton extends StatelessWidget {
  const DownloadButton({
    required this.label,
    required this.accent,
    this.outlined = false,
    super.key,
  });

  final String label;
  final Color accent;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: outlined ? Colors.transparent : accent,
        foregroundColor: outlined ? accent : CcatColors.background,
        side: BorderSide(color: accent),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
      ),
      child: Text('$label ↓'),
    );
  }
}

class RecordingAction extends StatelessWidget {
  const RecordingAction({required this.item, super.key});

  final ResourceItem item;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: item.accent,
        padding: EdgeInsets.zero,
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
      ),
      icon: const Icon(Icons.play_arrow_rounded, size: 18),
      label: const Text('Watch Recording'),
    );
  }
}

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 700;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: CcatColors.border)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: narrow ? 24 : 56,
          vertical: 34,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.start,
              runSpacing: 24,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CREATIVES FOR CLIMATE ACTION',
                      style: TextStyle(
                        color: CcatColors.purple,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .9,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'A project by Creative Migration',
                      style: TextStyle(
                        color: CcatColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FooterLink('Instagram', CcatColors.textPrimary),
                        FooterLink('LinkedIn', CcatColors.textPrimary),
                        FooterLink('Facebook', CcatColors.textPrimary),
                      ],
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CcatColors.purple,
                    side: const BorderSide(color: CcatColors.purple),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Donate',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(color: CcatColors.border),
            const SizedBox(height: 20),
            const Text(
              '© 2024–2026, Creative Migration, All rights reserved. Site by XXX',
              style: TextStyle(color: CcatColors.textMuted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class FooterLink extends StatelessWidget {
  const FooterLink(this.label, this.color, {super.key});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 18),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

enum ResourceType { publication, recording }

enum ResourceFilter {
  all('All Resources', CcatColors.textPrimary),
  publications('Publications & Toolkits 3', CcatColors.green),
  recordings('Video Recordings 4', CcatColors.coral);

  const ResourceFilter(this.label, this.accent);

  final String label;
  final Color accent;
}

class ResourceItem {
  const ResourceItem({
    required this.type,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.visualLabel,
    required this.accent,
    this.date,
    this.comingSoon = false,
  });

  final ResourceType type;
  final String eyebrow;
  final String title;
  final String description;
  final String visualLabel;
  final Color accent;
  final String? date;
  final bool comingSoon;
}

const resourceItems = <ResourceItem>[
  ResourceItem(
    type: ResourceType.publication,
    eyebrow: 'PUBLICATIONS · LAUNCHING OCTOBER 2026',
    title: 'Creative Responses to Sustainability — Thailand Guide',
    description:
        'Explore the Green Guide for Thailand, the latest edition in ASEF’s '
        'Creative Responses to Sustainability series, researched by Creative Migration.',
    visualLabel: 'GUIDE / 2026',
    accent: CcatColors.cyan,
    date: 'October, 2026',
    comingSoon: true,
  ),
  ResourceItem(
    type: ResourceType.publication,
    eyebrow: 'FIELD MANUAL · AVAILABLE NOW',
    title:
        'CCAT Field Manual 2025 — Sustainability Guidelines for BKKCAW Organizers',
    description:
        'A condensed version of the CCAT Toolkit 2024, adapted for BKKCAW 2025 '
        'organizers who need a simple footprint guide.',
    visualLabel: 'MANUAL / 2025',
    accent: CcatColors.green,
    date: 'September 13, 2025',
  ),
  ResourceItem(
    type: ResourceType.publication,
    eyebrow: 'TOOLKIT · FLAGSHIP RESOURCE',
    title: 'CCAT Toolkit 2024 — Sustainable Event Management',
    description:
        'A bilingual first-of-its-kind resource for Thailand’s festival and '
        'event industry’s green transition.',
    visualLabel: 'TOOLKIT / 2024',
    accent: CcatColors.gold,
    date: 'October 30, 2024',
  ),
  ResourceItem(
    type: ResourceType.recording,
    eyebrow: 'VIDEO RECORDING · November 20, 2025',
    title:
        'From Bangkok to Brazil: Culture-Based Climate Action Across the Global Majority',
    description:
        'Watch this discussion between cultural leaders from Thailand and Brazil '
        'exploring creativity, cultural work, and climate justice.',
    visualLabel: 'VIDEO',
    accent: CcatColors.coral,
  ),
  ResourceItem(
    type: ResourceType.recording,
    eyebrow: 'VIDEO RECORDING · May 22, 2025',
    title: 'Mobilizing Culture: Creative Leadership & Transnational Policy',
    description:
        'Watch the panel discussion held on International Day for Biodiversity, '
        'connecting LA Climate Week with BKKCAW.',
    visualLabel: 'VIDEO',
    accent: CcatColors.coral,
  ),
  ResourceItem(
    type: ResourceType.recording,
    eyebrow: 'CONFERENCE RECORDING · June 27, 2024',
    title: 'CCAT Conference 2024 — Day 2 Recording',
    description:
        'Watch the full recording of Day 2 of the inaugural CCAT Conference.',
    visualLabel: 'CONFERENCE',
    accent: CcatColors.gold,
  ),
  ResourceItem(
    type: ResourceType.recording,
    eyebrow: 'CONFERENCE RECORDING · June 26, 2024',
    title: 'CCAT Conference 2024 — Day 1 Recording',
    description:
        'Watch the full recording of Day 1 of the inaugural CCAT Conference.',
    visualLabel: 'CONFERENCE',
    accent: CcatColors.gold,
  ),
];

abstract final class CcatColors {
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFF1F1F1);
  static const selectedChip = Color(0xFFF1F2F8);
  static const visualShade = Color(0xFF18191B);
  static const border = Color(0xFF383838);
  static const textPrimary = Color(0xFF111111);
  static const textMuted = Color(0xFF5F5F5F);
  static const gold = Color(0xFFE6A530);
  static const green = Color(0xFF55C86A);
  static const cyan = Color(0xFF50B2D0);
  static const purple = Color(0xFF574CFF);
  static const coral = Color(0xFFEA704B);
  static const magenta = Color(0xFFD04C91);
}
