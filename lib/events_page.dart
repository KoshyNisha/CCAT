import 'package:flutter/material.dart';
import 'main.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({
    required this.isEnglish,
    required this.onLanguageChanged,
    super.key,
  });

  final bool isEnglish;
  final ValueChanged<bool> onLanguageChanged;

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  EventFilter _selectedFilter = EventFilter.all;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isNarrow = screenWidth < 760;

    final filteredEvents = eventItems.where((item) {
      switch (_selectedFilter) {
        case EventFilter.upcoming:
          return item.status == EventStatus.upcoming;
        case EventFilter.activeNow:
          return item.status == EventStatus.activeNow;
        case EventFilter.pastEvents:
          return item.status == EventStatus.past;
        case EventFilter.archive:
          return item.status == EventStatus.past;
        case EventFilter.all:
        default:
          return true;
      }
    }).toList();

    final featuredEvent = eventItems.firstWhere(
      (item) => item.isFeatured,
      orElse: () => eventItems.first,
    );

    final gridEvents = filteredEvents.where((e) => e != featuredEvent).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SiteHeader(
              isEnglish: widget.isEnglish,
              onLanguageSelected: widget.onLanguageChanged,
              currentIndex: 2,
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
                              EventFilters(
                                selected: _selectedFilter,
                                onSelected: (filter) {
                                  setState(() => _selectedFilter = filter);
                                },
                              ),
                              const SizedBox(height: 56),

                              if (filteredEvents.contains(featuredEvent)) ...[
                                FeaturedEventCard(
                                  item: featuredEvent,
                                  isNarrow: isNarrow,
                                ),
                                const SizedBox(height: 32),
                              ],

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

// ==========================================
// PAGE INTRO & ACCESSIBLE FILTER CHIPS
// ==========================================

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
          const Text(
            'CCAT / PROGRAMMING',
            style: TextStyle(
              color: CcatColors.green,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.1,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Events & Gatherings',
            style: TextStyle(
              color: CcatColors.textPrimary,
              fontSize: 48,
              height: 1.05,
              fontWeight: FontWeight.w400,
              letterSpacing: -2.2,
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: const Text(
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
          final accentColor = filter.accent;

          return Semantics(
            button: true,
            selected: isSelected,
            label: 'Filter by ${filter.label}',
            child: OutlinedButton(
              onPressed: () => onSelected(filter),
              style: ButtonStyle(
                elevation: const WidgetStatePropertyAll(0),
                shape: const WidgetStatePropertyAll(StadiumBorder()),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                ),
                side: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.disabled)) {
                    return BorderSide(color: accentColor.withValues(alpha: 0.3), width: 1.5);
                  }
                  return BorderSide(color: accentColor, width: 1.5);
                }),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.disabled)) {
                    return accentColor.withValues(alpha: 0.25);
                  }
                  if (isSelected) {
                    return accentColor; // Selected: 100% solid fill
                  }
                  if (states.contains(WidgetState.hovered)) {
                    return accentColor.withValues(alpha: 0.7); // Hovered: ~70% solid fill
                  }
                  return Colors.transparent; // Unselected: Outline only
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.disabled)) {
                    return accentColor.withValues(alpha: 0.4);
                  }
                  if (isSelected) {
                    return Colors.white; // Pure white text when selected
                  }
                  if (states.contains(WidgetState.hovered)) {
                    return const Color(0xFF111111); // Black text when hovered
                  }
                  return accentColor; // Default unselected text color
                }),
                textStyle: const WidgetStatePropertyAll(
                  TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              child: Text(filter.label),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ==========================================
// FEATURED & GRID CARDS
// ==========================================

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
                foregroundColor: (item.accent == CcatColors.gold || item.accent == CcatColors.green)
                    ? CcatColors.textPrimary
                    : Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: const StadiumBorder(),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: EventCard(item: rowItems[0]),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: rowItems.length > 1
                        ? EventCard(item: rowItems[1])
                        : const SizedBox.shrink(),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

// ==========================================
// ACCESSIBLE SITE FOOTER WITH RIGHT DONATE BUTTON
// ==========================================

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
            // Row 1: Brand details on left, Donate button on right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    shape: const StadiumBorder(),
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

// ==========================================
// ACCESSIBLE LANGUAGE TOGGLE WIDGET
// ==========================================

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
          color: CcatColors.coral, // Solid vivid accent background from spec
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent, // Active white pill
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? CcatColors.coral : Colors.white, // Active coral / Inactive white
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// DATA MODELS & ENUMS
// ==========================================

enum EventStatus { upcoming, activeNow, past }

enum EventFilter {
  all('All Events', CcatColors.textPrimary),
  upcoming('Upcoming', CcatColors.cyan),
  activeNow('Active Now', CcatColors.green),
  pastEvents('Past Events', CcatColors.purple),
  archive('Archive', CcatColors.gold);

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
        'A cross-regional dialogue as part of the official COP30 program at the Thailand Pavilion, bringing together cultural leaders from Thailand and Brazil to explore how creativity, governance and community collaboration can drive a just transition for the culture sector.',
    accent: CcatColors.cyan,
    dateText: 'November 20, 2025',
    buttonLabel: 'COP 30 Event',
    isFeatured: true,
  ),
  EventItem(
    status: EventStatus.activeNow,
    visualLabel: 'GLOBAL | HUB / THAILAND',
    title: 'CCAT Global Hub at Bangkok Climate Action Week 2025',
    description:
        'CCAT anchored the first-ever Bangkok Climate Action Week, transforming Bangkok 1088 into a Global Hub for climate and culture, hosting live performance, art exhibition and more.',
    accent: CcatColors.green,
    dateText: 'September 27 - October 4, 2025',
    buttonLabel: 'CCAT Global Hub Event',
  ),
  EventItem(
    status: EventStatus.upcoming,
    visualLabel: 'BACC / UPCOMING',
    title: 'CCAT Symposium at Bangkok Art and Culture Centre (BACC)',
    subtitle: 'An event by CCAT x Artistes & ClimateCats Studios',
    description:
        'Organized by CCAT, a full day of workshops and dialogue at BACC brought together artists, activists, and cultural workers to help shape the next edition of the CCAT Toolkit, build grassroots activism skills, and confront Thailand\'s air pollution crisis.',
    accent: CcatColors.cyan,
    dateText: 'November 12, 2025',
    buttonLabel: 'CCAT Symposium',
  ),
  EventItem(
    status: EventStatus.past,
    visualLabel: 'PURPLE / ARCHIVE',
    title: 'Mobilizing Culture: Creative Leadership & Transnational Policy',
    description:
        'A transnational panel discussion held on International Day for Biodiversity, connecting LA Climate Week with the first-ever Bangkok Climate Action Week to explore how creative communities drive climate action across borders.',
    accent: CcatColors.purple,
    dateText: 'May 22, 2025',
    buttonLabel: 'Mobilizing Culture',
  ),
  EventItem(
    status: EventStatus.past,
    visualLabel: 'GOLD / ARCHIVE',
    title: 'CCAT Conference 2024 — Bangkok',
    description:
        'The inaugural CCAT Conference united European and Thai stakeholders in the creative industry over two days at BACC Bangkok, delivering bilingual toolkits for sustainable event management and climate action.',
    accent: CcatColors.gold,
    dateText: 'June 26–27, 2024',
    buttonLabel: 'CCAT Conference 2024',
  ),
];