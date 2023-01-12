import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/audio_player/audio_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class TestWidgetWithAudioPlayer extends StatefulWidget {
  const TestWidgetWithAudioPlayer({super.key});

  @override
  State<StatefulWidget> createState() => TestStateWithAudioPlayer();
}

class TestStateWithAudioPlayer extends State<TestWidgetWithAudioPlayer>
    with AudioPlayerMixin {
  @override
  String get audioAssetPath => 'audioAssetPath';

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(LoopMode.all);
  });

  group('AudioPlayerMixin', () {
    late AudioPlayer audioPlayer;

    setUp(() {
      audioPlayer = _MockAudioPlayer();

      when(audioPlayer.pause).thenAnswer((_) async {});
      when(audioPlayer.play).thenAnswer((_) async {});
      when(audioPlayer.stop).thenAnswer((_) async {});
      when(audioPlayer.dispose).thenAnswer((_) async {});
      when(() => audioPlayer.setLoopMode(any())).thenAnswer((_) async {});
      when(() => audioPlayer.loopMode).thenReturn(LoopMode.off);
      when(() => audioPlayer.seek(any())).thenAnswer((_) async {});
      when(() => audioPlayer.setAsset(any()))
          .thenAnswer((_) async => Duration.zero);

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

    group('loadAudio', () {
      test('sets the audio asset', () async {
        final state = TestStateWithAudioPlayer();
        await state.loadAudio();
        verify(() => audioPlayer.setAsset('audioAssetPath')).called(1);
      });
    });

    group('playAudio', () {
      test(
        'sets the loop mode when loop is true and not already set',
        () async {
          final state = TestStateWithAudioPlayer();
          await state.playAudio(loop: true);
          verify(() => audioPlayer.setLoopMode(LoopMode.all)).called(1);
        },
      );

      test(
        'does not set the loop mode when loop is true and already set',
        () async {
          when(() => audioPlayer.loopMode).thenReturn(LoopMode.all);

          final state = TestStateWithAudioPlayer();
          await state.playAudio(loop: true);
          verifyNever(() => audioPlayer.setLoopMode(LoopMode.all));
        },
      );

      test('pauses, seeks, and plays the audio track', () async {
        final state = TestStateWithAudioPlayer();
        await state.playAudio();

        final verificationResults = verifyInOrder([
          () => audioPlayer.pause(),
          () => audioPlayer.seek(Duration.zero),
          () => audioPlayer.play(),
        ]);

        for (final f in verificationResults) {
          f.called(1);
        }
      });
    });

    group('stopAudio', () {
      test('calls stop on the audio player', () async {
        final state = TestStateWithAudioPlayer();
        await state.stopAudio();

        verify(() => audioPlayer.stop()).called(1);
      });
    });

    group('dispose', () {
      testWidgets('calls dispose on the audio player', (tester) async {
        await tester.pumpWidget(TestWidgetWithAudioPlayer());
        await tester.pumpAndSettle();
        await tester.pumpWidget(Container());

        verify(() => audioPlayer.dispose()).called(1);
      });

      testWidgets('waits for playing to end before calling dispose',
          (tester) async {
        final completer = Completer<void>();
        when(audioPlayer.play).thenAnswer((_) => completer.future);

        await tester.pumpWidget(TestWidgetWithAudioPlayer());
        await tester.pumpAndSettle();
        final playFuture = tester
            .state<TestStateWithAudioPlayer>(
              find.byType(TestWidgetWithAudioPlayer),
            )
            .playAudio();

        await tester.pumpWidget(Container());

        verifyNever(() => audioPlayer.dispose());

        completer.complete();
        await playFuture;
        await tester.pumpAndSettle();

        verify(() => audioPlayer.dispose()).called(1);
      });
    });
  });
}
