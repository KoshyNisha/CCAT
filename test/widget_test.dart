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
    void setSize(WidgetTester tester, Size size) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
    }

    // Pumps HomePage on its own so other tabs' layout issues don't leak in.
    Future<List<String>> pumpHome(WidgetTester tester, Size size) async {
      setSize(tester, size);
      final navigated = <String>[];
      var isEnglish = true;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) => HomePage(
              isEnglish: isEnglish,
              onLanguageChanged: (value) => setState(() => isEnglish = value),
              onNavigate: navigated.add,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return navigated;
    }

    testWidgets('app opens on the home tab', (tester) async {
      setSize(tester, const Size(1440, 1000));
      await tester.pumpWidget(const CcatApp());
      await tester.pumpAndSettle();

      expect(find.text('OUR WORK'), findsOneWidget);
      expect(find.text('LATEST UPDATES'), findsOneWidget);
    });

    testWidgets('desktop shows nav links and sections', (tester) async {
      await pumpHome(tester, const Size(1440, 1000));

      for (final link in ['About', 'News', 'Events', 'Resources', 'Contact']) {
        expect(find.text(link), findsWidgets);
      }
      expect(find.byTooltip('Menu'), findsNothing);
      expect(find.text('01 / 01'), findsOneWidget);
      expect(find.text('Read article →'), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });

    testWidgets('nav links and logo report where to go', (tester) async {
      final navigated = await pumpHome(tester, const Size(1440, 1000));

      await tester.tap(find.text('Events').first);
      await tester.tap(find.text('CCAT'));
      expect(navigated, ['Events', 'Home']);
    });

    testWidgets('phone layout uses a drawer and scrolls without overflow', (
      tester,
    ) async {
      final navigated = await pumpHome(tester, const Size(375, 812));

      await tester.tap(find.byTooltip('Menu'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(Drawer),
          matching: find.text('Resources'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsNothing);
      expect(navigated, ['Resources']);

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -6000),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('language toggle switches selection', (tester) async {
      await pumpHome(tester, const Size(1440, 1000));

      bool isSelected(String label) => tester
          .widgetList<Semantics>(
            find.ancestor(
              of: find.text(label),
              matching: find.byType(Semantics),
            ),
          )
          .any((w) => w.properties.selected == true);

      expect(isSelected('EN'), isTrue);
      await tester.tap(find.text('TH'));
      await tester.pump();
      expect(isSelected('TH'), isTrue);
      expect(isSelected('EN'), isFalse);
    });
  });
}
