import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_app/main.dart';

void main() {
  Future<void> pumpAtSize(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }

  testWidgets('desktop home page shows nav links and sections', (tester) async {
    await pumpAtSize(tester, const Size(1440, 1000));

    for (final link in ['About', 'News', 'Events', 'Resources', 'Contact']) {
      expect(find.text(link), findsWidgets);
    }
    expect(find.byTooltip('Menu'), findsNothing);
    expect(find.text('OUR WORK'), findsOneWidget);
    expect(find.text('LATEST UPDATES'), findsOneWidget);
    expect(find.text('01 / 01'), findsOneWidget);
    expect(find.text('Read article →'), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('phone layout collapses nav into a drawer without overflow', (
    tester,
  ) async {
    await pumpAtSize(tester, const Size(375, 812));

    expect(find.byTooltip('Menu'), findsOneWidget);
    expect(find.text('Resources'), findsOneWidget); // only the card title

    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);
    await tester.tap(find.text('Contact'));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsNothing);

    // Scroll the whole page to lay out every section at phone width.
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -6000),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('language toggle switches selection', (tester) async {
    await pumpAtSize(tester, const Size(1440, 1000));

    bool isSelected(String label) => tester
        .widgetList<Semantics>(
          find.ancestor(of: find.text(label), matching: find.byType(Semantics)),
        )
        .any((w) => w.properties.selected == true);

    expect(isSelected('EN'), isTrue);

    await tester.tap(find.text('TH'));
    await tester.pump();
    expect(isSelected('TH'), isTrue);
    expect(isSelected('EN'), isFalse);
  });
}
