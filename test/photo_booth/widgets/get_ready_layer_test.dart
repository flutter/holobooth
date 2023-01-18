import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/photo_booth/photo_booth.dart';

import '../../helpers/helpers.dart';

void main() {
  group('GetReadyLayer', () {
    testWidgets('renders GetReadyCountdown', (tester) async {
      await tester.pumpApp(GetReadyLayer(onCountdownCompleted: () {}));
      expect(find.byType(GetReadyCountdown), findsOneWidget);
    });

    testWidgets('calls onCountdownCompleted after animation completes',
        (tester) async {
      var onCountdownCompletedCalled = false;
      await tester.pumpApp(
        GetReadyLayer(
          onCountdownCompleted: () {
            onCountdownCompletedCalled = true;
          },
        ),
      );
      expect(onCountdownCompletedCalled, isFalse);
      await tester.pumpAndSettle();
      expect(onCountdownCompletedCalled, isTrue);
    });
  });
}
