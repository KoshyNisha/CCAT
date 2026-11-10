import 'package:flutter/material.dart';
import 'main.dart';
import 'events_page.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({
    required this.event,
    required this.isEnglish,
    required this.onLanguageChanged,
    required this.onBackToEvents,
    super.key,
  });

  final EventItem event;
  final bool isEnglish;
  final ValueChanged<bool> onLanguageChanged;
  final VoidCallback onBackToEvents;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isNarrow = screenWidth < 760;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SiteHeader(
              isEnglish: isEnglish,
              onLanguageSelected: onLanguageChanged,
              currentIndex: 2,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isNarrow ? 24 : 56,
                            vertical: 32,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton.icon(
                                onPressed: onBackToEvents,
                                icon: const Icon(Icons.arrow_back, size: 16),
                                label: const Text('All events'),
                                style: TextButton.styleFrom(
                                  foregroundColor: CcatColors.textPrimary,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                              const SizedBox(height: 24),

                              _EventHighlightHero(event: event, isNarrow: isNarrow),
                              const SizedBox(height: 48),

                              _EventMetadataRow(
                                isNarrow: isNarrow,
                                dateText: event.dateText,
                              ),
                              const SizedBox(height: 48),

                              Text(
                                event.title,
                                style: const TextStyle(
                                  color: CcatColors.textPrimary,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.8,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 720),
                                child: Text(
                                  '${event.description}\n\nExpect thoughtful conversations, music, and opportunities to meet others working across culture and climate. Join for the full day or drop in for the sessions that speak to you.',
                                  style: const TextStyle(
                                    color: CcatColors.textMuted,
                                    fontSize: 16,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 56),

                              const _ProgrammePreview(),
                              const SizedBox(height: 64),

                              _RegistrationCard(event: event),
                              const SizedBox(height: 96),
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

class _EventHighlightHero extends StatelessWidget {
  const _EventHighlightHero({required this.event, required this.isNarrow});

  final EventItem event;
  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: event.accent,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(isNarrow ? 20 : 36),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'EVENT HIGHLIGHT / 01',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'BANGKOK · THAILAND',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (isNarrow)
            Column(
              children: [
                _buildVisualPoster(),
                const SizedBox(height: 20),
                _buildInfoCard(),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildVisualPoster()),
                const SizedBox(width: 24),
                Expanded(child: _buildInfoCard()),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildVisualPoster() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: CcatColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CCAT PRESENTS',
            style: TextStyle(color: CcatColors.textMuted, fontSize: 11),
          ),
          const SizedBox(height: 12),
          Text(
            event.title,
            style: const TextStyle(
              color: CcatColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w600,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CcatColors.textPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  event.dateText?.toUpperCase() ?? 'UPCOMING\n2026',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'BANGKOK ↗',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: CcatColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: event.accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Events',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${event.dateText ?? "2026"} · Bangkok',
                style: const TextStyle(color: CcatColors.textMuted, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            event.title,
            style: const TextStyle(
              color: CcatColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            event.description,
            style: const TextStyle(
              color: CcatColors.textMuted,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 28),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.arrow_downward, size: 14),
            label: const Text('VIEW EVENT DETAILS'),
            style: TextButton.styleFrom(
              foregroundColor: CcatColors.textPrimary,
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventMetadataRow extends StatelessWidget {
  const _EventMetadataRow({required this.isNarrow, this.dateText});

  final bool isNarrow;
  final String? dateText;

  @override
  Widget build(BuildContext context) {
    final items = [
      _MetaItem(
        label: 'DATE & TIME',
        title: dateText ?? 'Sat, 21 Mar',
        subtitle: '10:00–17:00',
      ),
      const _MetaItem(
        label: 'LOCATION',
        title: 'Bangkok Art and Culture Centre',
        subtitle: 'Pathum Wan, Bangkok',
      ),
      const _MetaItem(
        label: 'ADMISSION',
        title: 'Free',
        subtitle: 'Registration required',
      ),
    ];

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: e,
        )).toList(),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((e) => Expanded(child: e)).toList(),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.label,
    required this.title,
    required this.subtitle,
  });

  final String label;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: CcatColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            color: CcatColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(color: CcatColors.textMuted, fontSize: 13),
        ),
      ],
    );
  }
}

class _ProgrammePreview extends StatelessWidget {
  const _ProgrammePreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Programme preview',
              style: TextStyle(
                color: CcatColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Schedule subject to change',
              style: TextStyle(color: CcatColors.textMuted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(color: CcatColors.border),
        const _ProgramRow(time: '10:00', title: 'Doors open & welcome'),
        const Divider(color: CcatColors.border),
        const _ProgramRow(time: '11:00', title: 'Creative voices on culture and climate'),
        const Divider(color: CcatColors.border),
        const _ProgramRow(time: '14:00', title: 'Hands-on ideas & community workshops'),
        const Divider(color: CcatColors.border),
      ],
    );
  }
}

class _ProgramRow extends StatelessWidget {
  const _ProgramRow({required this.time, required this.title});

  final String time;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              time,
              style: const TextStyle(
                color: CcatColors.textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: CcatColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RegistrationCard extends StatelessWidget {
  const _RegistrationCard({required this.event});

  final EventItem event;

  @override
  Widget build(BuildContext context) {
    final isPast = event.status == EventStatus.past;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: CcatColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CcatColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isPast ? 'Registration Closed' : 'Save your place',
                style: const TextStyle(
                  color: CcatColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isPast
                    ? 'Registration closed for this event'
                    : 'Free admission · Registration link to be added',
                style: const TextStyle(color: CcatColors.textMuted, fontSize: 13),
              ),
            ],
          ),
          OutlinedButton(
            onPressed: isPast ? null : () {}, // Setting onPressed to null disables the button
            style: OutlinedButton.styleFrom(
              foregroundColor: isPast ? CcatColors.textMuted : CcatColors.textPrimary,
              side: BorderSide(
                color: isPast ? CcatColors.border : CcatColors.border,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: const StadiumBorder(),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isPast ? 'Registration closed' : 'Registration link'),
                const SizedBox(width: 8),
                Icon(
                  isPast ? Icons.lock_outline : Icons.arrow_forward,
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}