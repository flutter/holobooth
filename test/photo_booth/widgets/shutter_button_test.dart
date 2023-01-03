import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockAnimationController extends Mock implements AnimationController {}

class _MockCanvas extends Mock implements Canvas {}

class _RectFake extends Fake implements Rect {}

class _MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AudioPlayer audioPlayer;

  setUp(() {
    audioPlayer = _MockAudioPlayer();
    when(() => audioPlayer.setAsset(any())).thenAnswer((_) async => null);
    when(() => audioPlayer.load()).thenAnswer((_) async {
      return null;
    });
    when(() => audioPlayer.play()).thenAnswer((_) async {});
    when(() => audioPlayer.pause()).thenAnswer((_) async {});
    when(() => audioPlayer.stop()).thenAnswer((_) async {});
    when(() => audioPlayer.seek(any())).thenAnswer((_) async {});
    when(() => audioPlayer.dispose()).thenAnswer((_) async {});
    when(() => audioPlayer.playerStateStream).thenAnswer(
      (_) => Stream.fromIterable(
        [
          PlayerState(true, ProcessingState.ready),
        ],
      ),
    );

    const MethodChannel('com.ryanheise.audio_session')
        .setMockMethodCallHandler((call) async {
      if (call.method == 'getConfiguration') {
        return {};
      }
    });
  });

  group('ShutterButton', () {
    testWidgets(
      'set asset correctly',
      (WidgetTester tester) async {
        await tester.pumpApp(
          ShutterButton(
            onCountdownCompleted: () {},
            audioPlayer: () => audioPlayer,
          ),
        );
        await tester.pumpAndSettle();
        verify(() => audioPlayer.setAsset(any())).called(1);
      },
    );
    testWidgets('renders', (tester) async {
      await tester.pumpApp(
        ShutterButton(
          onCountdownCompleted: () {},
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ShutterButton), findsOneWidget);
    });

    testWidgets('renders CameraButton when animation has not started',
        (tester) async {
      await tester.pumpApp(
        ShutterButton(
          onCountdownCompleted: () {},
        ),
      );
      expect(find.byType(CountdownTimer), findsNothing);
    });
  });

  group('TimerPainter', () {
    late AnimationController animation;

    setUp(() {
      animation = _MockAnimationController();
      registerFallbackValue(Paint());
      registerFallbackValue(const Offset(200, 200));
      registerFallbackValue(_RectFake());
    });

    test('verifies should not repaint', () async {
      final timePainter =
          TimerPainter(animation: animation, controllerValue: 3);
      expect(timePainter.shouldRepaint(timePainter), false);
    });

    test('verify paints correctly', () {
      when(() => animation.value).thenReturn(2);

      final canvas = _MockCanvas();

      TimerPainter(animation: animation, controllerValue: 3)
          .paint(canvas, const Size(200, 200));

      verify(() => canvas.drawCircle(any(), any(), any())).called(1);
      verify(() => canvas.drawArc(any(), any(), any(), any(), any())).called(1);
    });
  });
}
