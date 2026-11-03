import 'package:flutter/material.dart';

void main() {
  runApp(const CcatEventsApp());
}

class CcatEventsApp extends StatelessWidget {
  const CcatEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CCAT | Events',
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
      home: const EventsPage(),
    );
  }
}

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  EventFilter _selectedFilter = EventFilter.all;
  bool _isEnglish = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isNarrow = screenWidth < 760;

    final filteredEvents = eventItems
        .where((item) {
          switch (_selectedFilter) {
            case EventFilter.upcoming:
              return item.status == EventStatus.upcoming;
            case EventFilter.activeNow:
              return item.status == EventStatus.activeNow;
            case EventFilter.pastEvents:
              return item.status == EventStatus.past;
            case EventFilter.all:
            default:
              return true;
          }
        })
        .toList();

    final featuredEvent = eventItems.firstWhere(
      (item) => item.isFeatured,
      orElse: () => eventItems.first,
    );

    final gridEvents = filteredEvents.where((e) => !e.isFeatured).toList();

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
                            isNarrow ? 48 : 80,
                            isNarrow ? 24 : 56,
                            0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const PageIntroduction(),
                              const SizedBox(height: 34),
                              EventFilters(
                                selected: _selectedFilter,
                                onSelected: (filter) {
                                  setState(() => _selectedFilter = filter);
                                },
                              ),
                              const SizedBox(height: 48),

                              // Featured Wide Card
                              if (filteredEvents.contains(featuredEvent)) ...[
                                FeaturedEventCard(
                                  item: featuredEvent,
                                  isNarrow: isNarrow,
                                ),
                                const SizedBox(height: 32),
                              ],

                              // Responsive Event Grid
                              EventGrid(
                                items: gridEvents,
                                isNarrow: isNarrow,
                              ),

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

class PageIntroduction extends StatelessWidget {
  const PageIntroduction({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      header: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CCAT / PROGRAMMING',
            style: TextStyle(
              color: CcatColors.green,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.1,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Events & Gatherings',
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
              'Discover international summits, local symposia, workshops, and collaborative hubs bringing together creative leaders, policymakers, and climate advocates.',
              style: TextStyle(
                color: CcatColors.textMuted,
                fontSize: 17,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventFilters extends StatelessWidget {
  const EventFilters({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final EventFilter selected;
  final ValueChanged<EventFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Filter events list',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: EventFilter.values.map((filter) {
          final isSelected = selected == filter;

          // Determine accessible text color for light mode
          final Color textColor = isSelected
              ? _getAccessibleSelectedTextColor(filter.accent)
              : filter.accent;

          return Semantics(
            button: true,
            selected: isSelected,
            label: 'Filter by ${filter.label}',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelected(filter),
                borderRadius: BorderRadius.circular(24),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? filter.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: filter.accent,
                      width: isSelected ? 2.0 : 1.5,
                    ),
                  ),
                  child: Text(
                    filter.label,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Ensures dark text on light accents (Gold, Green) and white text on dark accents (Coral, Purple)
  Color _getAccessibleSelectedTextColor(Color accent) {
    if (accent == CcatColors.gold || accent == CcatColors.green) {
      return CcatColors.textPrimary; // Dark text (#111111)
    }
    return CcatColors.background; // White text (#FFFFFF)
  }
}

class FeaturedEventCard extends StatelessWidget {
  const FeaturedEventCard({
    required this.item,
    required this.isNarrow,
    super.key,
  });

  final EventItem item;
  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Featured Event: ${item.title}',
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: CcatColors.surface,
          border: Border.all(color: CcatColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: isNarrow
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 240,
                    child: VisualBanner(item: item),
                  ),
                  _buildCardContent(padding: const EdgeInsets.all(28)),
                ],
              )
            : IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 5,
                      child: VisualBanner(item: item),
                    ),
                    Expanded(
                      flex: 6,
                      child: _buildCardContent(
                        padding: const EdgeInsets.all(48),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCardContent({required EdgeInsets padding}) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              StatusBadge(status: item.status, accent: item.accent),
              if (item.dateText != null)
                Text(
                  item.dateText!,
                  style: const TextStyle(
                    color: CcatColors.textMuted,
                    fontSize: 13,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            item.title,
            style: const TextStyle(
              color: CcatColors.textPrimary,
              fontSize: 32,
              height: 1.15,
              fontWeight: FontWeight.w500,
              letterSpacing: -1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            style: const TextStyle(
              color: CcatColors.textMuted,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: item.accent,
                foregroundColor: CcatColors.background,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: Text(
                'Learn more about ${item.buttonLabel ?? 'Event'}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventGrid extends StatelessWidget {
  const EventGrid({
    required this.items,
    required this.isNarrow,
    super.key,
  });

  final List<EventItem> items;
  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    if (isNarrow) {
      // Single-column layout for mobile
      return Column(
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: EventCard(item: item),
            ),
        ],
      );
    }

    // 2-column layout for desktop with matching row heights
    final rows = <List<EventItem>>[];
    for (var i = 0; i < items.length; i += 2) {
      rows.add(
        items.sublist(
          i,
          i + 2 > items.length ? items.length : i + 2,
        ),
      );
    }

    return Column(
      children: [
        for (final rowItems in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Stretches both cards to equal height
                children: [
                  Expanded(
                    child: EventCard(item: rowItems[0]),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: rowItems.length > 1
                        ? EventCard(item: rowItems[1])
                        : const SizedBox.shrink(), // Empty placeholder if odd number of cards
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({required this.item, super.key});

  final EventItem item;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Event: ${item.title}',
      child: Container(
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
              height: 220,
              child: VisualBanner(item: item),
            ),
            Expanded( // Allows content area to fill available vertical space
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes bottom button to equal alignment
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            StatusBadge(status: item.status, accent: item.accent),
                            if (item.dateText != null)
                              Text(
                                item.dateText!,
                                style: const TextStyle(
                                  color: CcatColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: CcatColors.textPrimary,
                            fontSize: 22,
                            height: 1.18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -.8,
                          ),
                        ),
                        if (item.subtitle != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            item.subtitle!,
                            style: const TextStyle(
                              color: CcatColors.cyan,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Text(
                          item.description,
                          style: const TextStyle(
                            color: CcatColors.textMuted,
                            fontSize: 14,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 48),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: item.accent,
                            padding: EdgeInsets.zero,
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Learn more about ${item.buttonLabel ?? 'Event'}',
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_rounded, size: 14),
                            ],
                          ),
                        ),
                      ),
                    ),
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

class VisualBanner extends StatelessWidget {
  const VisualBanner({required this.item, super.key});

  final EventItem item;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            item.accent.withValues(alpha: .9),
            CcatColors.visualShade,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Semantics(
            label: 'Tag: ${item.visualLabel}',
            child: Container(
              color: CcatColors.textPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, required this.accent, super.key});

  final EventStatus status;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    String label;
    switch (status) {
      case EventStatus.upcoming:
        label = 'UPCOMING EVENT';
        break;
      case EventStatus.activeNow:
        label = 'HAPPENING NOW';
        break;
      case EventStatus.past:
        label = 'PAST EVENT';
        break;
    }

    return Semantics(
      label: 'Status: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: accent, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: accent,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: .5,
          ),
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
    final narrow = MediaQuery.sizeOf(context).width < 1000;

    return Container(
      height: 72,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: CcatColors.border)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: narrow ? 24 : 56),
        child: Row(
          children: [
            Semantics(
              header: true,
              label: 'Creatives for Climate Action Home',
              child: const Text(
                'CCAT',
                style: TextStyle(
                  color: CcatColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.3,
                ),
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
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu_rounded),
                color: CcatColors.textPrimary,
                tooltip: 'Open navigation menu',
              ),
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
            child: Semantics(
              button: true,
              selected: entry == 'Events',
              label: '$entry navigation link',
              child: InkWell(
                onTap: () {},
                child: Text(
                  entry,
                  style: TextStyle(
                    color: entry == 'Events'
                        ? CcatColors.green
                        : CcatColors.textMuted,
                    fontSize: 14,
                    fontWeight: entry == 'Events'
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
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
    return Semantics(
      label: 'Language selector',
      child: Container(
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
    return Semantics(
      button: true,
      selected: selected,
      label: 'Switch language to $label',
      child: InkWell(
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
      ),
    );
  }
}

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 700;

    return Semantics(
      container: true,
      label: 'Footer section',
      child: Container(
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
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CcatColors.purple, // Light mode vivid accent
                      foregroundColor: Colors.white,      // Accessible white text
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 16,
                      ),
                      shape: const StadiumBorder(), // Pill shape
                    ),
                    child: const Text(
                      'Donate',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  )
                  // ConstrainedBox(
                  //   constraints: const BoxConstraints(minHeight: 48),
                  //   child: OutlinedButton(
                  //     onPressed: () {},
                  //     style: OutlinedButton.styleFrom(
                  //       foregroundColor: CcatColors.purple,
                  //       side: const BorderSide(color: CcatColors.purple),
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 26,
                  //         vertical: 16,
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       'Donate',
                  //       style: TextStyle(fontWeight: FontWeight.w800),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 32),
              const Divider(color: CcatColors.border),
              const SizedBox(height: 20),
              const Text(
                '© 2024–2026, Creative Migration, All rights reserved.',
                style: TextStyle(color: CcatColors.textMuted, fontSize: 11),
              ),
            ],
          ),
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
      child: Semantics(
        link: true,
        label: '$label link',
        child: InkWell(
          onTap: () {},
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

enum EventStatus { upcoming, activeNow, past }

enum EventFilter {
  all('All Events', CcatColors.textPrimary),
  upcoming('• Upcoming', CcatColors.cyan),
  activeNow('• Active Now', CcatColors.green),
  pastEvents('• Past Events / Archive', CcatColors.purple);

  const EventFilter(this.label, this.accent);

  final String label;
  final Color accent;
}

class EventItem {
  const EventItem({
    required this.status,
    required this.visualLabel,
    required this.title,
    required this.description,
    required this.accent,
    this.subtitle,
    this.dateText,
    this.buttonLabel,
    this.isFeatured = false,
  });

  final EventStatus status;
  final String visualLabel;
  final String title;
  final String? subtitle;
  final String description;
  final Color accent;
  final String? dateText;
  final String? buttonLabel;
  final bool isFeatured;
}

final eventItems = <EventItem>[
  EventItem(
    status: EventStatus.upcoming,
    visualLabel: 'COP30 | THAILAND x BRAZIL',
    title: 'Culture for Climate Action: Thailand x Brazil at COP30',
    description:
        'A cross-regional dialogue as part of the official COP30 program...',
    accent: CcatColors.cyan,
    dateText: 'November 20, 2025',
    buttonLabel: 'COP 30 Event',
    isFeatured: true, // ONLY THIS ONE IS FEATURED
  ),
  EventItem(
    status: EventStatus.activeNow,
    visualLabel: 'GLOBAL | HUB / THAILAND',
    title: 'CCAT Global Hub at Bangkok Climate Action Week 2025',
    description:
        'CCAT anchored the first-ever Bangkok Climate Action Week...',
    accent: CcatColors.green,
    dateText: 'September 27 - October 4, 2025',
    buttonLabel: 'CCAT Global Hub Event',
    // isFeatured is false by default
  ),
  EventItem(
    status: EventStatus.upcoming,
    visualLabel: 'BACC / UPCOMING',
    title: 'CCAT Symposium at Bangkok Art and Culture Centre (BACC)',
    subtitle: 'An event by CCAT x Artistes & ClimateCats Studios',
    description:
        'Organized by CCAT, a full day of workshops and dialogue at BACC...',
    accent: CcatColors.cyan,
    dateText: 'November 12, 2025',
    buttonLabel: 'CCAT Symposium',
  ),
  EventItem(
    status: EventStatus.past,
    visualLabel: 'PURPLE / ARCHIVE',
    title: 'Mobilizing Culture: Creative Leadership & Transnational Policy',
    description:
        'A transnational panel discussion held on International Day for Biodiversity...',
    accent: CcatColors.purple,
    dateText: 'May 22, 2025',
    buttonLabel: 'Mobilizing Culture',
  ),
  EventItem(
    status: EventStatus.past,
    visualLabel: 'GOLD / ARCHIVE',
    title: 'CCAT Conference 2024 — Bangkok',
    description:
        'The inaugural CCAT Conference united European and Thai stakeholders...',
    accent: CcatColors.gold,
    dateText: 'June 26–27, 2024',
    buttonLabel: 'CCAT Conference 2024',
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