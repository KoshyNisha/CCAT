import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/main.dart';
import 'package:my_flutter_app/pages/home_page.dart';

void main() {
  testWidgets('renders the resources knowledge hub', (tester) async {
    await tester.pumpWidget(const CcatApp());

    expect(find.text('Resources & Knowledge Hub'), findsOneWidget);
    expect(find.text('Publications & Toolkits'), findsOneWidget);
    expect(find.text('Session Recordings & Discussions'), findsOneWidget);
    expect(
      find.text('Creative Responses to Sustainability — Thailand Guide'),
      findsOneWidget,
    );
  });

  testWidgets('filters to publications and toolkits', (tester) async {
    await tester.pumpWidget(const CcatApp());

    final publicationsFilter = find.text('Publications & Toolkits 3');
    await tester.ensureVisible(publicationsFilter);
    await tester.tap(publicationsFilter);
    await tester.pump();

    expect(
      find.text(
        'CCAT Field Manual 2025 — Sustainability Guidelines for BKKCAW Organizers',
      ),
      findsOneWidget,
    );
    expect(find.text('Session Recordings & Discussions'), findsNothing);
  });

  testWidgets('opens the About page from the navigation', (tester) async {
    await tester.pumpWidget(const CcatApp());

    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text('The Beginnings'), findsOneWidget);
    expect(find.text('From a Conference to an Initiative'), findsOneWidget);
    expect(find.text('Key Milestones'), findsOneWidget);
    expect(find.text('Our Partners'), findsOneWidget);
  });

  testWidgets('opens a PDF resource highlight', (tester) async {
    await tester.pumpWidget(const CcatApp());

    final guide = find.text(
      'Creative Responses to Sustainability — Thailand Guide',
    );
    await tester.ensureVisible(guide);
    await tester.tap(guide);
    await tester.pumpAndSettle();

    expect(find.text('PDF RESOURCE / 01'), findsOneWidget);
    expect(find.text('Download PDF'), findsOneWidget);
  });

  testWidgets('navigates from a PDF highlight to the About tab', (
    tester,
  ) async {
    await tester.pumpWidget(const CcatApp());

    final guide = find.text(
      'Creative Responses to Sustainability — Thailand Guide',
    );
    await tester.ensureVisible(guide);
    await tester.tap(guide);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text('The Beginnings'), findsOneWidget);
    expect(find.text('PDF RESOURCE / 01'), findsNothing);
  });

  testWidgets('opens a video resource highlight', (tester) async {
    await tester.pumpWidget(const CcatApp());

    final recording = find.text(
      'From Bangkok to Brazil: Culture-Based Climate Action Across the Global Majority',
    );
    await tester.ensureVisible(recording);
    await tester.tap(recording);
    await tester.pumpAndSettle();

    expect(find.text('VIDEO RESOURCE / 01'), findsOneWidget);
    expect(find.text('Watch online'), findsOneWidget);
  });

  group('home page', () {
    // Wider than the real 1440 design: the test font is wider than real
    // fonts and would overflow the shared header's nav row at 1440.
    const desktop = Size(1800, 1000);
    // The shared footer's social row needs ~400px in the test font.
    const phone = Size(430, 932);

    Future<void> pumpApp(WidgetTester tester, Size size) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const CcatApp());
      await tester.pumpAndSettle();
    }

    testWidgets('app opens on the home page', (tester) async {
      await pumpApp(tester, desktop);

      expect(find.text('OUR WORK'), findsOneWidget);
      expect(find.text('LATEST UPDATES'), findsOneWidget);
      expect(find.text('01 / 01'), findsOneWidget);
      expect(find.text('Read article'), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });

    testWidgets('shared header navigates away and the logo comes back', (
      tester,
    ) async {
      await pumpApp(tester, desktop);

      await tester.tap(find.text('Events').first);
      await tester.pumpAndSettle();
      expect(find.text('OUR WORK'), findsNothing);
      expect(find.text('Events & Gatherings'), findsOneWidget);

      await tester.tap(find.text('CCAT').first);
      await tester.pumpAndSettle();
      expect(find.text('OUR WORK'), findsOneWidget);
    });

    testWidgets('explore links open the matching tabs', (tester) async {
      const links = {
        'Explore all events': 'Events & Gatherings',
        'Explore library': 'Resources & Knowledge Hub',
        'Explore all news': 'News Page Content Coming Soon',
      };
      for (final MapEntry(key: link, value: pageText) in links.entries) {
        await tester.pumpWidget(const SizedBox()); // fresh app state each time
        await pumpApp(tester, desktop);
        await tester.ensureVisible(find.text(link));
        await tester.tap(find.text(link));
        await tester.pumpAndSettle();
        expect(find.text('OUR WORK'), findsNothing, reason: link);
        expect(find.text(pageText), findsOneWidget, reason: link);
      }
    });

    testWidgets('footer social links point to CCAT profiles', (tester) async {
      await pumpApp(tester, desktop);

      String? urlOf(String label) =>
          tester.widget<FooterLink>(find.widgetWithText(FooterLink, label)).url;
      expect(
        urlOf('Instagram'),
        'https://www.instagram.com/creatives_climateaction',
      );
      expect(
        urlOf('LinkedIn'),
        'https://www.linkedin.com/company/creatives-for-climate-action-thailand/',
      );
      expect(
        urlOf('Facebook'),
        'https://www.facebook.com/creativesforclimateactionglobal',
      );
    });

    // Pumps HomePage alone: the Events tab's cards overflow at phone width
    // (events_page.dart) and would fail this test otherwise.
    testWidgets('phone layout scrolls end to end without overflow', (
      tester,
    ) async {
      tester.view.physicalSize = phone;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(home: HomePage(isEnglish: true, onLanguageChanged: (_) {})),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -6000),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
