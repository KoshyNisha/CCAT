import 'package:flutter/material.dart';

import 'main.dart' show CcatColors, SiteFooter, SiteHeader;

class AboutPage extends StatelessWidget {
  const AboutPage({
    required this.isEnglish,
    required this.onLanguageChanged,
    required this.onOpenEvents,
    super.key,
  });

  final bool isEnglish;
  final ValueChanged<bool> onLanguageChanged;
  final VoidCallback onOpenEvents;

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
              currentIndex: 5,
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
                              _AboutMilestones(onOpenEvents: onOpenEvents),
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
  const _AboutMilestones({required this.onOpenEvents});

  final VoidCallback onOpenEvents;

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
          onPressed: onOpenEvents,
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
