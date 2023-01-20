import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/photo_booth/widgets/widgets.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockAudioPlayer extends Mock implements just_audio.AudioPlayer {}

void main() {
  setUpAll(() {
    registerFallbackValue(just_audio.LoopMode.all);
  });

  group('HoloBoothCharacterError', () {
    late just_audio.AudioPlayer audioPlayer;

    setUp(() {
      audioPlayer = _MockAudioPlayer();

      when(audioPlayer.pause).thenAnswer((_) async {});
      when(audioPlayer.play).thenAnswer((_) async {});
      when(audioPlayer.dispose).thenAnswer((_) async {});
      when(() => audioPlayer.setLoopMode(any())).thenAnswer((_) async {});
      when(() => audioPlayer.loopMode).thenReturn(just_audio.LoopMode.off);
      when(() => audioPlayer.seek(any())).thenAnswer((_) async {});
      when(() => audioPlayer.setAsset(any()))
          .thenAnswer((_) async => Duration.zero);

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

    test('can be instantiated', () {
      expect(HoloBoothCharacterError(), isNotNull);
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(HoloBoothCharacterError());
      expect(find.byType(HoloBoothCharacterError), findsOneWidget);
    });

    testWidgets('plays audio', (tester) async {
      await tester.pumpApp(HoloBoothCharacterError());
      await tester.pumpAndSettle();

      verify(() => audioPlayer.setAsset(Assets.audio.faceNotDetected))
          .called(1);
      verify(audioPlayer.play).called(1);
    });
  });
}
