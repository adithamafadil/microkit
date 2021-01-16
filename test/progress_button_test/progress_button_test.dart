import 'package:flutter_test/flutter_test.dart';
import 'package:microkit/microkit.dart';

import 'sources/progress_button_standby_test_app.dart';
import 'sources/progress_button_loading_test.dart';

void main() {
  group('Testing from stand by state into loading.', () {
    testWidgets('Changed State from Stand by to loading', (tester) async {
      await tester.pumpWidget(ProgressStandbyTestApp(
        currentState: ButtonStates.standby,
        nextState: ButtonStates.loading,
      ));

      expect(find.widgetWithText(ProgressButton, 'Refetch'), findsOneWidget);

      await tester.tap(find.widgetWithText(ProgressButton, 'Refetch'));
      await tester.pump();

      expect(find.widgetWithText(ProgressButton, 'Refetch'), findsNothing);

      expect(find.widgetWithText(ProgressButton, 'Loading'), findsOneWidget);
    });
  });

  group('Testing from stand by to succeed', () {
    testWidgets('Changed State from loading to succeed', (tester) async {
      await tester.pumpWidget(ProgressLoadingTestApp(
        currentState: ButtonStates.standby,
        nextState: ButtonStates.succeed,
      ));
      expect(find.widgetWithText(ProgressButton, 'Refetch'), findsOneWidget);

      await tester.tap(find.widgetWithText(ProgressButton, 'Refetch'));
      await tester.pump();

      expect(find.widgetWithText(ProgressButton, 'Refetch'), findsNothing);
      expect(find.widgetWithText(ProgressButton, 'Loading'), findsNothing);
      expect(find.widgetWithText(ProgressButton, 'Succeed'), findsOneWidget);
    });
  });

  group('Testing from stand by to failed', () {
    testWidgets('Changed State from loading to succeed', (tester) async {
      await tester.pumpWidget(ProgressLoadingTestApp(
        currentState: ButtonStates.standby,
        nextState: ButtonStates.failed,
      ));
      expect(find.widgetWithText(ProgressButton, 'Refetch'), findsOneWidget);

      await tester.tap(find.widgetWithText(ProgressButton, 'Refetch'));
      await tester.pump();

      expect(find.widgetWithText(ProgressButton, 'Refetch'), findsNothing);
      expect(find.widgetWithText(ProgressButton, 'Loading'), findsNothing);
      expect(find.widgetWithText(ProgressButton, 'Failed'), findsOneWidget);
    });
  });
}
