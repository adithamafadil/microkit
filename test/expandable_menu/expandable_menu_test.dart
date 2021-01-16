import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'source/expandable_menu_app_test.dart';

// import 'source/expandable_menu_app_test.dart';

void main() {
  group('Testing Expandable Menu', () {
    testWidgets('Expandable Menu Tapped', (tester) async {
      await tester.pumpWidget(ExpandableMenuTest());
      expect(find.widgetWithText(InkWell, 'Collapse'), findsOneWidget);
      await tester.tap(find.widgetWithText(InkWell, 'Collapse'));
      await tester.pump();
      expect(find.widgetWithText(InkWell, 'Collapse'), findsNothing);
      expect(find.widgetWithText(InkWell, 'Expand'), findsOneWidget);
    });
  });
}
