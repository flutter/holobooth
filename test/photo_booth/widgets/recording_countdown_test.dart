import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockAnimationController extends Mock implements AnimationController {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ShutterButton', () {
    testWidgets('renders', (tester) async {
      await tester.pumpApp(
        RecordingCountdown(
          onCountdownCompleted: () {},
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(RecordingCountdown), findsOneWidget);
    });
  });

  group('TimerPainter', () {
    late AnimationController animation;

    setUp(() {
      animation = _MockAnimationController();
    });

    test('verifies should not repaint', () async {
      final timePainter =
          TimerPainter(animation: animation, controllerValue: 3);
      expect(timePainter.shouldRepaint(timePainter), false);
    });
  });
}
