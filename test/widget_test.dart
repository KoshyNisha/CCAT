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
}
