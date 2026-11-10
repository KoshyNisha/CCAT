import 'package:flutter/material.dart';
import 'events_page.dart';
import 'event_highlight_page.dart';

void main() {
  runApp(const CcatApp());
}

class CcatApp extends StatelessWidget {
  const CcatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CCAT | Creatives for Climate Action',
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
      home: const MainScreen(),
    );
  }
}

/// Central screen that handles bottom/header navigation between all 5 pages
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; // Default to Events tab
  bool _isEnglish = true;
  EventItem? _selectedEvent; // Holds active event detail

  List<Widget> get _pages => [
    AboutPage(
      isEnglish: _isEnglish,
      onLanguageChanged: (val) => setState(() => _isEnglish = val),
    ),
    NewsPage(
      isEnglish: _isEnglish,
      onLanguageChanged: (val) => setState(() => _isEnglish = val),
    ),
    _buildEventsTab(), // <-- MUST call this helper method
    ResourcesPage(
      isEnglish: _isEnglish,
      onLanguageChanged: (val) => setState(() => _isEnglish = val),
    ),
    ContactPage(
      isEnglish: _isEnglish,
      onLanguageChanged: (val) => setState(() => _isEnglish = val),
    ),
  ];

  Widget _buildEventsTab() {
    if (_selectedEvent != null) {
      return EventDetailPage(
        event: _selectedEvent!,
        isEnglish: _isEnglish,
        onLanguageChanged: (val) => setState(() => _isEnglish = val),
        onBackToEvents: () => setState(() => _selectedEvent = null),
      );
    }

    return EventsPage(
      isEnglish: _isEnglish,
      onLanguageChanged: (val) => setState(() => _isEnglish = val),
      onEventSelected: (event) => setState(() => _selectedEvent = event),
    );
  }
  
  // ... rest of _MainScreenState

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
    );
  }
}

// ==========================================
// 1. RESOURCES PAGE (Your original code[cite: 1])
// ==========================================
class ResourcesPage extends StatefulWidget {
  const ResourcesPage({
    required this.isEnglish,
    required this.onLanguageChanged,
    super.key,
  });

  final bool isEnglish;
  final ValueChanged<bool> onLanguageChanged;

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  ResourceFilter _selectedFilter = ResourceFilter.all;

  void _openResource(ResourceItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResourceHighlightPage(
          item: item,
          initialIsEnglish: widget.isEnglish,
          onTabSelected: (index) {
            Navigator.of(context).pop();
            context.findAncestorStateOfType<_MainScreenState>()?._navigateToTab(
              index,
            );
          },
        ),
      ),
    );
  }

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
              isEnglish: widget.isEnglish,
              onLanguageSelected: widget.onLanguageChanged,
              currentIndex: 3,
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
                                  onOpen: _openResource,
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
                                  onOpen: _openResource,
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

class AboutPage extends StatelessWidget {
  const AboutPage({
    required this.isEnglish,
    required this.onLanguageChanged,
    super.key,
  });

  final bool isEnglish;
  final ValueChanged<bool> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 760;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SiteHeader(
              isEnglish: isEnglish,
              onLanguageSelected: onLanguageChanged,
              currentIndex: 0,
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
                            narrow ? 24 : 56,
                            narrow ? 80 : 132,
                            narrow ? 24 : 56,
                            112,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _AboutHeroMark(),
                              SizedBox(height: narrow ? 92 : 178),
                              const _AboutBeginning(),
                              SizedBox(height: narrow ? 96 : 160),
                              const _AboutConference(),
                              SizedBox(height: narrow ? 96 : 144),
                              const _AboutMilestones(),
                              SizedBox(height: narrow ? 96 : 144),
                              const _AboutPartners(),
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

class _AboutHeroMark extends StatelessWidget {
  const _AboutHeroMark();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Icon(Icons.eco_outlined, color: CcatColors.gold, size: 20),
          SizedBox(height: 12),
          Text(
            'CREATIVES FOR CLIMATE ACTION',
            style: TextStyle(
              color: CcatColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'For a climate-conscious creative economy',
            style: TextStyle(color: CcatColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _AboutBeginning extends StatelessWidget {
  const _AboutBeginning();

  @override
  Widget build(BuildContext context) {
    return _AboutSplitSection(
      label: 'ABOUT / THE BEGINNINGS',
      title: 'The Beginnings',
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Creatives for Climate Action — Thailand (CCAT) began as a single '
            'conference, held June 26–27, 2024, at the Thailand Creative & '
            'Design Center (TCDC) in Bangkok and online. The first edition was '
            'a project by UNESCO Culture Thailand, produced by Creative '
            'Migration and in collaboration with the Creative Economy Agency '
            '(CEA), and brought together Thai and European festival organizers, '
            'sustainability experts, artists, and policymakers to share best '
            'practices and develop actionable tools for climate action within '
            'the creative economy.',
            style: _AboutTextStyle.body,
          ),
          SizedBox(height: 22),
          Text(
            'The conference responded to a specific and structural gap: '
            'Southeast Asia’s cultural and creative sector holds a unique role '
            'of influence. It shapes how people imagine the future, what they '
            'value, and how they organize, while also sharing real production '
            'challenges around venues, travel, waste, and resource use. CCAT '
            'creates the conditions to move from conversation to action.',
            style: _AboutTextStyle.body,
          ),
        ],
      ),
    );
  }
}

class _AboutConference extends StatelessWidget {
  const _AboutConference();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 860;
        final copy = const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What started as a one-off gathering quickly grew into the '
              'beginning of something longer-term. In the months following the '
              '2024 conference, Creative Migration received permission from '
              'UNESCO to continue and expand the work.',
              style: _AboutTextStyle.body,
            ),
            SizedBox(height: 18),
            Text(
              'Since then, Creative Migration has continued to build out '
              'CCAT’s core resource, the CCAT Toolkit, while representing '
              'Southeast Asian creatives in cultural and climate gatherings '
              'across the Global North and Global South — from panels at G20 '
              'Brazil and Los Angeles Climate Week, to industry summits in '
              'Singapore and beyond.',
              style: _AboutTextStyle.body,
            ),
          ],
        );

        final visual = const _ConferenceVisual();
        return _AboutSplitSection(
          label: '',
          title: 'From a Conference to an Initiative',
          child: narrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [copy, const SizedBox(height: 36), visual],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: copy),
                    const SizedBox(width: 72),
                    const Expanded(child: _ConferenceVisual()),
                  ],
                ),
        );
      },
    );
  }
}

class _ConferenceVisual extends StatelessWidget {
  const _ConferenceVisual();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 258,
      width: double.infinity,
      decoration: BoxDecoration(
        color: CcatColors.visualShade,
        borderRadius: BorderRadius.circular(9),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_outline, color: CcatColors.coral, size: 28),
            SizedBox(height: 14),
            Text(
              'CCAT / 2024',
              style: TextStyle(
                color: CcatColors.coral,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Conference still',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutMilestones extends StatelessWidget {
  const _AboutMilestones();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AboutSectionHeading(title: 'Key Milestones'),
        const SizedBox(height: 34),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: CcatColors.coral, width: 1.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final milestone in _aboutMilestones)
                _MilestoneItem(milestone: milestone),
            ],
          ),
        ),
        const SizedBox(height: 28),
        OutlinedButton(
          onPressed: () {
            context.findAncestorStateOfType<_MainScreenState>()?._navigateToTab(
              2,
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: CcatColors.coral,
            side: const BorderSide(color: CcatColors.coral),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
          child: const Text(
            'Explore all events',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _MilestoneItem extends StatelessWidget {
  const _MilestoneItem({required this.milestone});

  final _Milestone milestone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            milestone.date,
            style: const TextStyle(
              color: CcatColors.coral,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 7),
          Text(milestone.description, style: _AboutTextStyle.milestone),
          const SizedBox(height: 7),
          Text(
            milestone.reference,
            style: const TextStyle(
              color: CcatColors.coral,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: .45,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutPartners extends StatelessWidget {
  const _AboutPartners();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AboutSectionHeading(title: 'Our Partners'),
        SizedBox(height: 20),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 900),
          child: Text(
            'CCAT is made possible through the collaboration of institutional, '
            'cultural and industry partners across Thailand, Europe and beyond. '
            'Thank you to everyone who has supported this work so far.',
            style: _AboutTextStyle.body,
          ),
        ),
      ],
    );
  }
}

class _AboutSplitSection extends StatelessWidget {
  const _AboutSplitSection({
    required this.label,
    required this.title,
    required this.child,
  });

  final String label;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 760;
        final heading = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 32, child: Divider(color: CcatColors.coral)),
            const SizedBox(height: 18),
            Text(title, style: _AboutTextStyle.sectionTitle),
            if (label.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(label, style: _AboutTextStyle.label),
            ],
          ],
        );

        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [heading, const SizedBox(height: 32), child],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 300, child: heading),
            const SizedBox(width: 76),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}

class _AboutSectionHeading extends StatelessWidget {
  const _AboutSectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 32, child: Divider(color: CcatColors.coral)),
        const SizedBox(height: 18),
        Text(title, style: _AboutTextStyle.sectionTitle),
      ],
    );
  }
}

abstract final class _AboutTextStyle {
  static const sectionTitle = TextStyle(
    color: CcatColors.textPrimary,
    fontSize: 28,
    height: 1.1,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
  );
  static const label = TextStyle(
    color: CcatColors.gold,
    fontSize: 10,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.15,
  );
  static const body = TextStyle(
    color: CcatColors.textMuted,
    fontSize: 15,
    height: 1.62,
  );
  static const milestone = TextStyle(
    color: CcatColors.textMuted,
    fontSize: 13,
    height: 1.5,
  );
}

class _Milestone {
  const _Milestone(this.date, this.description, this.reference);

  final String date;
  final String description;
  final String reference;
}

const _aboutMilestones = [
  _Milestone(
    'JUNE 26–27, 2024',
    'The first CCAT conference was held at TCDC Bangkok and online, bringing '
        'together European and Thai stakeholders in the creative industries.',
    'LEARN MORE ABOUT CCAT CONFERENCE 2024 →',
  ),
  _Milestone(
    'OCTOBER 30, 2024',
    'The CCAT Toolkit 2024 launched at a press event hosted by the Austrian '
        'Embassy in Bangkok.',
    'LEARN MORE ABOUT CCAT TOOLKIT 2024 →',
  ),
  _Milestone(
    'NOVEMBER, 2024',
    'CCAT contributed to the International Seminar on Culture and Climate '
        'Change during G20 Brazil, sharing Southeast Asia’s experience '
        'developing practical sustainability tools for cultural sectors.',
    'LEARN MORE ABOUT G20 BRAZIL →',
  ),
  _Milestone(
    'MAY 22, 2025',
    'CCAT co-organized “Mobilizing Culture: Creative Leadership & '
        'Transnational Policy,” connecting Los Angeles Climate Week with the '
        'first-ever Bangkok Climate Action Week.',
    'LEARN MORE ABOUT THE PANEL RECORDING →',
  ),
  _Milestone(
    'SEPTEMBER 2025',
    'A condensed CCAT Field Manual was released to support cultural organizers '
        'during Bangkok Climate Action Week.',
    'LEARN MORE ABOUT CCAT FIELD MANUAL 2025 →',
  ),
  _Milestone(
    'SEPTEMBER 2025',
    'CCAT hosted programming during Bangkok Climate Action Week (BKKCAW), '
        'bringing the initiative into dialogue with the city’s climate action '
        'community.',
    'LEARN MORE ABOUT BKKCAW →',
  ),
];

class NewsPage extends StatelessWidget {
  const NewsPage({
    required this.isEnglish,
    required this.onLanguageChanged,
    super.key,
  });
  final bool isEnglish;
  final ValueChanged<bool> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SiteHeader(
              isEnglish: isEnglish,
              onLanguageSelected: onLanguageChanged,
              currentIndex: 1,
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'News Page Content Coming Soon',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({
    required this.isEnglish,
    required this.onLanguageChanged,
    super.key,
  });
  final bool isEnglish;
  final ValueChanged<bool> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SiteHeader(
              isEnglish: isEnglish,
              onLanguageSelected: onLanguageChanged,
              currentIndex: 4,
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Contact Page Content Coming Soon',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SHARED COMPONENTS (Header, Footer, etc.)
// ==========================================
class SiteHeader extends StatelessWidget {
  const SiteHeader({
    required this.isEnglish,
    required this.onLanguageSelected,
    required this.currentIndex,
    this.onTabSelected,
    super.key,
  });

  final bool isEnglish;
  final ValueChanged<bool> onLanguageSelected;
  final int currentIndex;
  final ValueChanged<int>? onTabSelected;

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
            GestureDetector(
              onTap: () => _selectTab(context, 3),
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
            if (!narrow)
              DesktopNavigation(
                currentIndex: currentIndex,
                onTabSelected: onTabSelected,
              ),
            if (narrow)
              IconButton(
                icon: const Icon(
                  Icons.menu_rounded,
                  color: CcatColors.textPrimary,
                ),
                onPressed: () {
                  // Open Mobile Drawer Menu
                  _showNavigationDrawer(context);
                },
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

  void _showNavigationDrawer(BuildContext context) {
    final mainScreen = context.findAncestorStateOfType<_MainScreenState>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CcatColors.background,
      builder: (context) {
        const entries = ['About', 'News', 'Events', 'Resources', 'Contact'];
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  for (int i = 0; i < entries.length; i++)
                    ListTile(
                      title: Text(
                        entries[i],
                        style: TextStyle(
                          fontWeight: i == currentIndex
                              ? FontWeight.w800
                              : FontWeight.w500,
                          color: i == currentIndex
                              ? CcatColors.green
                              : CcatColors.textPrimary,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        if (onTabSelected != null) {
                          onTabSelected!(i);
                        } else {
                          mainScreen?._navigateToTab(i);
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectTab(BuildContext context, int index) {
    if (onTabSelected != null) {
      onTabSelected!(index);
      return;
    }

    context.findAncestorStateOfType<_MainScreenState>()?._navigateToTab(index);
  }
}

class DesktopNavigation extends StatelessWidget {
  const DesktopNavigation({
    required this.currentIndex,
    this.onTabSelected,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int>? onTabSelected;

  @override
  Widget build(BuildContext context) {
    const entries = ['About', 'News', 'Events', 'Resources', 'Contact'];

    return Row(
      children: [
        for (int i = 0; i < entries.length; i++)
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: InkWell(
              onTap: () {
                if (onTabSelected != null) {
                  onTabSelected!(i);
                } else {
                  context
                      .findAncestorStateOfType<_MainScreenState>()
                      ?._navigateToTab(i);
                }
              },
              child: Text(
                entries[i],
                style: TextStyle(
                  color: i == currentIndex
                      ? CcatColors.green
                      : CcatColors.textMuted,
                  fontSize: 14,
                  fontWeight: i == currentIndex
                      ? FontWeight.w700
                      : FontWeight.w500,
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
          color: Colors.white, // White capsule background
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: CcatColors.border), // Clean outline matching site design
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
            color: selected ? CcatColors.coral : Colors.transparent, // Active orange/coral pill
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : CcatColors.textMuted, // White text on orange / Muted text on white
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
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
        const Text(
          'CCAT / OPEN LIBRARY',
          style: TextStyle(
            color: CcatColors.green,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.1,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Resources & Knowledge Hub',
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
  const ResourceGrid({
    required this.items,
    required this.narrow,
    required this.onOpen,
    super.key,
  });

  final List<ResourceItem> items;
  final bool narrow;
  final ValueChanged<ResourceItem> onOpen;

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
                child: ResourceCard(item: item, onOpen: () => onOpen(item)),
              ),
          ],
        );
      },
    );
  }
}

class ResourceCard extends StatelessWidget {
  const ResourceCard({required this.item, required this.onOpen, super.key});

  final ResourceItem item;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onOpen,
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
                      PublicationActions(item: item, onOpen: onOpen)
                    else
                      RecordingAction(item: item, onOpen: onOpen),
                  ],
                ),
              ),
            ],
          ),
        ),
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
  const PublicationActions({
    required this.item,
    required this.onOpen,
    super.key,
  });

  final ResourceItem item;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    if (item.comingSoon) {
      return OutlinedButton(
        onPressed: onOpen,
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
        DownloadButton(
          label: 'English PDF',
          accent: item.accent,
          onPressed: onOpen,
        ),
        DownloadButton(
          label: 'Thai PDF',
          accent: item.accent,
          onPressed: onOpen,
          outlined: true,
        ),
      ],
    );
  }
}

class DownloadButton extends StatelessWidget {
  const DownloadButton({
    required this.label,
    required this.accent,
    required this.onPressed,
    this.outlined = false,
    super.key,
  });

  final String label;
  final Color accent;
  final VoidCallback onPressed;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
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
  const RecordingAction({required this.item, required this.onOpen, super.key});

  final ResourceItem item;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onOpen,
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
            // Top Row: Brand Info on Left | Donate Button on Right (ABOVE Divider)
            if (narrow)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBrandBlock(),
                  const SizedBox(height: 24),
                  _buildDonateButton(),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBrandBlock(),
                  _buildDonateButton(),
                ],
              ),

            const SizedBox(height: 32),
            const Divider(color: CcatColors.border),
            const SizedBox(height: 20),

            // Bottom Row: Copyright Only (BELOW Divider)
            const Text(
              '© 2024–2026, Creative Migration, All rights reserved. Site by XXX',
              style: TextStyle(color: CcatColors.textMuted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandBlock() {
    return const Column(
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
    );
  }

  Widget _buildDonateButton() {
    return OutlinedButton(
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
    );
  }
}

  Widget _buildDonateButton() {
    return OutlinedButton(
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
    );
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
    this.detailDescription,
    this.comingSoon = false,
  });

  final ResourceType type;
  final String eyebrow;
  final String title;
  final String description;
  final String visualLabel;
  final Color accent;
  final String? date;
  final String? detailDescription;
  final bool comingSoon;
}

class ResourceHighlightPage extends StatefulWidget {
  const ResourceHighlightPage({
    required this.item,
    required this.initialIsEnglish,
    required this.onTabSelected,
    super.key,
  });

  final ResourceItem item;
  final bool initialIsEnglish;
  final ValueChanged<int> onTabSelected;

  @override
  State<ResourceHighlightPage> createState() => _ResourceHighlightPageState();
}

class _ResourceHighlightPageState extends State<ResourceHighlightPage> {
  late bool _isEnglish = widget.initialIsEnglish;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SiteHeader(
              isEnglish: _isEnglish,
              onLanguageSelected: (isEnglish) {
                setState(() => _isEnglish = isEnglish);
              },
              currentIndex: 3,
              onTabSelected: widget.onTabSelected,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1600),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(56, 48, 56, 112),
                          child: item.type == ResourceType.publication
                              ? PdfHighlight(item: item)
                              : VideoHighlight(item: item),
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

class PdfHighlight extends StatelessWidget {
  const PdfHighlight({required this.item, super.key});

  final ResourceItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HighlightHero(item: item, isVideo: false),
        const SizedBox(height: 36),
        BackToResources(),
        const SizedBox(height: 56),
        HighlightIntro(item: item),
        const SizedBox(height: 60),
        PdfPreview(item: item),
        const SizedBox(height: 38),
        DownloadPanel(item: item),
      ],
    );
  }
}

class VideoHighlight extends StatelessWidget {
  const VideoHighlight({required this.item, super.key});

  final ResourceItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HighlightHero(item: item, isVideo: true),
        const SizedBox(height: 36),
        BackToResources(),
        const SizedBox(height: 56),
        HighlightIntro(item: item),
        const SizedBox(height: 48),
        VideoPlayerStill(item: item),
        const SizedBox(height: 32),
        Text(
          _videoDetailCopy(item),
          style: const TextStyle(
            color: CcatColors.textMuted,
            fontSize: 16,
            height: 1.65,
          ),
        ),
      ],
    );
  }
}

class HighlightHero extends StatelessWidget {
  const HighlightHero({required this.item, required this.isVideo, super.key});

  final ResourceItem item;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 900;
        final left = Container(
          constraints: const BoxConstraints(minHeight: 410),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                item.accent.withValues(alpha: .9),
                CcatColors.visualShade,
              ],
            ),
          ),
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isVideo ? 'VIDEO RESOURCE / 01' : 'PDF RESOURCE / 01',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              if (isVideo)
                const Text(
                  'Video still',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              const SizedBox(height: 8),
              Text(
                isVideo ? 'Watch online' : 'Digital guide',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
        final details = Container(
          constraints: const BoxConstraints(minHeight: 356),
          padding: const EdgeInsets.all(38),
          decoration: BoxDecoration(
            color: CcatColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: CcatColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(
                label: Text(isVideo ? 'VIDEO' : 'PDF GUIDE'),
                backgroundColor: item.accent,
                labelStyle: const TextStyle(
                  color: CcatColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
                side: BorderSide.none,
              ),
              const SizedBox(height: 24),
              Text(
                item.title,
                style: const TextStyle(
                  color: CcatColors.textPrimary,
                  fontSize: 37,
                  height: 1.05,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.8,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                item.description,
                style: const TextStyle(
                  color: CcatColors.textMuted,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              TextButton.icon(
                onPressed: () => _showUnavailableMessage(context, isVideo),
                style: TextButton.styleFrom(
                  foregroundColor: item.accent,
                  padding: EdgeInsets.zero,
                ),
                icon: Icon(
                  isVideo ? Icons.play_arrow_rounded : Icons.download_rounded,
                ),
                label: Text(
                  isVideo ? 'WATCH THE VIDEO' : 'DOWNLOAD PDF',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        );

        if (narrow) {
          return Column(children: [left, const SizedBox(height: 18), details]);
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 6, child: left),
            const SizedBox(width: 18),
            Expanded(flex: 5, child: details),
          ],
        );
      },
    );
  }
}

class BackToResources extends StatelessWidget {
  const BackToResources({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => Navigator.of(context).pop(),
      style: TextButton.styleFrom(
        foregroundColor: CcatColors.green,
        padding: EdgeInsets.zero,
      ),
      icon: const Icon(Icons.arrow_back, size: 18),
      label: const Text(
        'All resources',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class HighlightIntro extends StatelessWidget {
  const HighlightIntro({required this.item, super.key});

  final ResourceItem item;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 850),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.type == ResourceType.publication
                ? 'PDF RESOURCE'
                : 'VIDEO RESOURCE',
            style: TextStyle(
              color: item.accent,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            item.type == ResourceType.publication
                ? 'A practical guide for creative climate work'
                : item.title,
            style: const TextStyle(
              color: CcatColors.textPrimary,
              fontSize: 30,
              height: 1.1,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.1,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            _detailDescription(item),
            style: const TextStyle(
              color: CcatColors.textMuted,
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class PdfPreview extends StatelessWidget {
  const PdfPreview({required this.item, super.key});

  final ResourceItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 900),
      height: 490,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CcatColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CcatColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: CcatColors.textPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Row(
              children: [
                Text(
                  'PDF PREVIEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Spacer(),
                Text(
                  '100%',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 390,
                margin: const EdgeInsets.all(22),
                padding: const EdgeInsets.all(34),
                color: CcatColors.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title.toUpperCase(),
                      style: const TextStyle(
                        color: CcatColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Resource preview',
                      style: TextStyle(
                        color: item.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Download the complete resource to read the full guide.',
                      style: TextStyle(
                        color: CcatColors.textPrimary,
                        fontSize: 26,
                        height: 1.08,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DownloadPanel extends StatelessWidget {
  const DownloadPanel({required this.item, super.key});

  final ResourceItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 900),
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: CcatColors.border)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 18,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Keep a copy for your team',
                style: TextStyle(
                  color: CcatColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${item.date ?? 'PDF resource'} · English / Thai',
                style: const TextStyle(
                  color: CcatColors.textMuted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          FilledButton.icon(
            onPressed: () => _showUnavailableMessage(context, false),
            style: FilledButton.styleFrom(
              backgroundColor: item.accent,
              foregroundColor: CcatColors.textPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            icon: const Icon(Icons.download_rounded),
            label: const Text(
              'Download PDF',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerStill extends StatelessWidget {
  const VideoPlayerStill({required this.item, super.key});

  final ResourceItem item;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 900),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [item.accent, CcatColors.visualShade],
          ),
        ),
        child: Center(
          child: FilledButton.icon(
            onPressed: () => _showUnavailableMessage(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: CcatColors.background,
              foregroundColor: CcatColors.textPrimary,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(22),
            ),
            icon: const Icon(Icons.play_arrow_rounded, size: 32),
            label: const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

void _showUnavailableMessage(BuildContext context, bool isVideo) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        isVideo
            ? 'The video link will be added with the final resource data.'
            : 'The PDF download link will be added with the final resource data.',
      ),
    ),
  );
}

String _detailDescription(ResourceItem item) {
  return item.detailDescription ?? item.description;
}

String _videoDetailCopy(ResourceItem item) {
  return '${item.detailDescription ?? item.description} The resource brief '
      'identifies this as a video recording but does not provide a published '
      'video URL, speaker credits, captions, or a still image yet.';
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
    detailDescription:
        'The guide maps the evolving intersection of art and environmental '
        'stewardship in Thailand, covering national and global policy contexts, '
        'creative interventions for local arts organizations, and a curated '
        'directory of pioneering rural and urban initiatives. Publication '
        'launches in October 2026.',
    comingSoon: true,
  ),
  ResourceItem(
    type: ResourceType.publication,
    eyebrow: 'FIELD MANUAL · AVAILABLE NOW',
    title:
        'CCAT Field Manual 2025 — Sustainability Guidelines for BKKCAW Organizers',
    description:
        'A condensed version of the CCAT Toolkit 2024, adapted for BKKCAW 2025 '
        'organizers who need a simple guide to offset their environmental '
        'footprint, including an updated directory.',
    visualLabel: 'MANUAL / 2025',
    accent: CcatColors.green,
    date: 'September 13, 2025',
  ),
  ResourceItem(
    type: ResourceType.publication,
    eyebrow: 'TOOLKIT · FLAGSHIP RESOURCE',
    title:
        'CCAT Toolkit 2024 — Sustainable Event Management for Thailand’s Creative Economy',
    description:
        'A bilingual first-of-its-kind resource for Thailand’s festival and '
        'event industry’s green transition.',
    visualLabel: 'TOOLKIT / 2024',
    accent: CcatColors.gold,
    date: 'October 30, 2024',
    detailDescription:
        'Developed from the inaugural CCAT Conference and published in October '
        '2024, the Toolkit offers practical self-assessment tools, sustainability '
        'guidance, and a directory of vendors, venues, and consultants across '
        'catering, mobility, energy and water, and waste management.',
  ),
  ResourceItem(
    type: ResourceType.recording,
    eyebrow: 'VIDEO RECORDING · November 20, 2025',
    title:
        'From Bangkok to Brazil: Culture-Based Climate Action Across the Global Majority',
    description:
        'Watch this discussion between cultural leaders from Thailand and Brazil '
        'exploring how creativity, cultural policy, and community collaboration '
        'can strengthen climate action and justice.',
    visualLabel: 'VIDEO',
    accent: CcatColors.coral,
  ),
  ResourceItem(
    type: ResourceType.recording,
    eyebrow: 'VIDEO RECORDING · May 22, 2025',
    title:
        'Mobilizing Culture: Creative Leadership & Transnational Policy — Panel Recording',
    description:
        'Watch the recording of a panel discussion held on May 22, 2025 '
        '(International Day for Biodiversity), connecting LA Climate Week with '
        'the first-ever Bangkok Climate Action Week (BKKCAW).',
    visualLabel: 'VIDEO',
    accent: CcatColors.coral,
  ),
  ResourceItem(
    type: ResourceType.recording,
    eyebrow: 'CONFERENCE RECORDING · June 27, 2024',
    title: 'CCAT Conference 2024 — Day 2 Recording',
    description:
        'Watch the full recording of Day 2 of the Creatives for Climate Action '
        '— Thailand Conference, held on June 27, 2024 at the Thailand Creative '
        '& Design Center in Bangkok and online.',
    visualLabel: 'CONFERENCE',
    accent: CcatColors.gold,
  ),
  ResourceItem(
    type: ResourceType.recording,
    eyebrow: 'CONFERENCE RECORDING · June 26, 2024',
    title: 'CCAT Conference 2024 — Day 1 Recording',
    description:
        'Watch the full recording of Day 1 of the Creatives for Climate Action '
        '— Thailand Conference, held on June 26, 2024 at the Thailand Creative '
        '& Design Center in Bangkok and online.',
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


