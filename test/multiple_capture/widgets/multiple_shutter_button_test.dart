import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';

import '../../helpers/helpers.dart';

void main() {
  group('MultipleShutterButton', () {
    testWidgets('renders', (tester) async {
      await tester.pumpApp(
        MultipleShutterButton(
          onShutter: () async {},
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(MultipleShutterButton), findsOneWidget);
    });

    testWidgets('renders CameraButton when animation has not started',
        (tester) async {
      await tester.pumpApp(
        MultipleShutterButton(
          onShutter: () async {},
        ),
      );
      expect(find.byType(CameraButton), findsOneWidget);
      expect(find.byType(CountdownTimer), findsNothing);
    });

    testWidgets('renders CountdownTimer when clicks on CameraButton with audio',
        (tester) async {
      await tester.pumpApp(
        MultipleShutterButton(
          onShutter: () async {},
        ),
      );
      await tester.tap(find.byType(CameraButton));
      await tester.pump();
      expect(find.byType(CountdownTimer), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets(
      'onShutter is called',
      (WidgetTester tester) async {
        var count = 0;
        await tester.pumpApp(
          MultipleShutterButton(
            onShutter: () async {
              count++;
            },
          ),
        );
        await tester.tap(find.byType(CameraButton));
        await tester.pumpAndSettle();
        expect(count, 5);
      },
    );
  });
}
