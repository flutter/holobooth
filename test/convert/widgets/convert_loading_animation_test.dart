import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AudioPlayer audioPlayer;

  setUpAll(() {
    registerFallbackValue(LoopMode.off);
  });

  setUp(() {
    audioPlayer = _MockAudioPlayer();
    when(() => audioPlayer.setAsset(any())).thenAnswer((_) async => null);
    when(() => audioPlayer.setLoopMode(any())).thenAnswer((_) async {});
    when(() => audioPlayer.play()).thenAnswer((_) async {});
    when(() => audioPlayer.stop()).thenAnswer((_) async {});
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

  group('ConvertLoadingView', () {
    testWidgets(
      'set asset correctly',
      (WidgetTester tester) async {
        await tester.pumpApp(
          ConvertLoadingAnimation(
            dimension: 300,
            audioPlayer: () => audioPlayer,
          ),
        );
        await tester.pump();
        verify(() => audioPlayer.setAsset(any())).called(1);
      },
    );

    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ConvertLoadingAnimation(
            dimension: 300,
          ),
        ),
      );

      expect(find.byType(ConvertLoadingAnimation), findsOneWidget);
    });

    testWidgets(
      'calls stop on AppLifecycleState.paused',
      (WidgetTester tester) async {
        await tester.pumpApp(
          ConvertLoadingAnimation(
            dimension: 300,
            audioPlayer: () => audioPlayer,
          ),
        );
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pump();
        verify(() => audioPlayer.stop()).called(1);
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await tester.pump();
      },
    );
  });
}
