import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:invasivex/main.dart';

void main() {
  testWidgets('App launches to the Identify tab', (WidgetTester tester) async {
    await tester.pumpWidget(const InvasiveXApp());

    expect(find.text('Identify a Species'), findsOneWidget);
    expect(find.text('Take Photo'), findsOneWidget);
    expect(find.text('Choose from Library'), findsOneWidget);
  });

  testWidgets('Library tab lists curated species', (WidgetTester tester) async {
    await tester.pumpWidget(const InvasiveXApp());

    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();

    expect(find.text('Spotted Lanternfly'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Kudzu'), 300, scrollable: find.byType(Scrollable));
    expect(find.text('Kudzu'), findsOneWidget);
  });
}
