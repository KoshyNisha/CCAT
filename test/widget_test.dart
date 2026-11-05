import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/main.dart';

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
}
