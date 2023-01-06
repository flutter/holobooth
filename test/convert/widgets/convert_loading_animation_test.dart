import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/audio_player/audio_player.dart';
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
    AudioPlayerMixin.audioPlayerOverride = audioPlayer;

    const MethodChannel('com.ryanheise.audio_session')
        .setMockMethodCallHandler((call) async {
      if (call.method == 'getConfiguration') {
        return {};
      }
    });
  });

  tearDown(() {
    AudioPlayerMixin.audioPlayerOverride = null;
  });

  group('ConvertLoadingView', () {
    testWidgets(
      'set asset correctly',
      (WidgetTester tester) async {
        await tester.pumpApp(
          ConvertLoadingAnimation(
            dimension: 300,
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
  });
}
