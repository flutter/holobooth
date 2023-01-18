import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockAudioPlayer extends Mock implements just_audio.AudioPlayer {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late just_audio.AudioPlayer audioPlayer;

  setUpAll(() {
    registerFallbackValue(just_audio.LoopMode.off);
  });

  setUp(() {
    audioPlayer = _MockAudioPlayer();
    when(() => audioPlayer.loopMode).thenReturn(just_audio.LoopMode.off);
    when(() => audioPlayer.setAsset(any())).thenAnswer((_) async => null);
    when(() => audioPlayer.setLoopMode(any())).thenAnswer((_) async {});
    when(() => audioPlayer.play()).thenAnswer((_) async {});
    when(() => audioPlayer.stop()).thenAnswer((_) async {});
    when(() => audioPlayer.dispose()).thenAnswer((_) async {});
    when(() => audioPlayer.playerStateStream).thenAnswer(
      (_) => Stream.fromIterable(
        [
          just_audio.PlayerState(true, just_audio.ProcessingState.ready),
        ],
      ),
    );
    AudioPlayer.audioPlayerOverride = audioPlayer;

    const MethodChannel('com.ryanheise.audio_session')
        .setMockMethodCallHandler((call) async {
      if (call.method == 'getConfiguration') {
        return {};
      }
    });
  });

  tearDown(() {
    AudioPlayer.audioPlayerOverride = null;
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
      await tester.pumpApp(
        ConvertLoadingAnimation(
          dimension: 300,
        ),
      );

      expect(find.byType(ConvertLoadingAnimation), findsOneWidget);
    });
  });
}
