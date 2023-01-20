import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockAudioPlayer extends Mock implements just_audio.AudioPlayer {}

class _MockMuteSoundBloc extends MockBloc<MuteSoundEvent, MuteSoundState>
    implements MuteSoundBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(just_audio.LoopMode.all);
  });

  group('AudioPlayer', () {
    const child = SizedBox(key: Key('child'));
    late just_audio.AudioPlayer audioPlayer;

    setUp(() {
      audioPlayer = _MockAudioPlayer();

      when(audioPlayer.pause).thenAnswer((_) async {});
      when(audioPlayer.play).thenAnswer((_) async {});
      when(audioPlayer.stop).thenAnswer((_) async {});
      when(audioPlayer.dispose).thenAnswer((_) async {});
      when(() => audioPlayer.setLoopMode(any())).thenAnswer((_) async {});
      when(() => audioPlayer.setVolume(any())).thenAnswer((_) async {});
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

    testWidgets('sets the audio asset', (tester) async {
      await tester.pumpApp(
        AudioPlayer(
          audioAssetPath: 'audioAssetPath',
          child: child,
        ),
      );

      verify(() => audioPlayer.setAsset('audioAssetPath')).called(1);
    });

    testWidgets('plays the audio when autoplay is true', (tester) async {
      await tester.pumpApp(
        AudioPlayer(
          audioAssetPath: 'audioAssetPath',
          autoplay: true,
          child: child,
        ),
      );

      verify(audioPlayer.play).called(1);
    });

    testWidgets('renders the child', (tester) async {
      await tester.pumpApp(
        AudioPlayer(
          audioAssetPath: 'audioAssetPath',
          child: child,
        ),
      );

      expect(find.byWidget(child), findsOneWidget);
    });

    testWidgets(
      'sets the loop mode when loop is true and not already set',
      (tester) async {
        await tester.pumpApp(
          AudioPlayer(
            audioAssetPath: 'audioAssetPath',
            loop: true,
            child: child,
          ),
        );

        verify(
          () => audioPlayer.setLoopMode(just_audio.LoopMode.all),
        ).called(1);
      },
    );

    testWidgets(
      'does not set the loop mode when loop is true and already set',
      (tester) async {
        when(() => audioPlayer.loopMode).thenReturn(just_audio.LoopMode.all);

        await tester.pumpApp(
          AudioPlayer(
            audioAssetPath: 'audioAssetPath',
            loop: true,
            child: child,
          ),
        );

        verifyNever(() => audioPlayer.setLoopMode(just_audio.LoopMode.all));
      },
    );

    testWidgets('sets the volume when muted', (tester) async {
      final muteSoundBloc = _MockMuteSoundBloc();
      when(() => muteSoundBloc.state).thenReturn(MuteSoundState(isMuted: true));
      await tester.pumpApp(
        AudioPlayer(
          audioAssetPath: 'audioAssetPath',
          child: child,
        ),
        muteSoundBloc: muteSoundBloc,
      );

      verify(() => audioPlayer.setVolume(0)).called(1);
    });

    group('playAudio', () {
      testWidgets('calls stop on the audio player if playing fails',
          (tester) async {
        final controller = AudioPlayerController();
        when(audioPlayer.play).thenThrow(Exception());

        await tester.pumpApp(
          AudioPlayer(
            audioAssetPath: 'audioAssetPath',
            controller: controller,
            child: child,
          ),
        );
        await controller.playAudio();

        verify(() => audioPlayer.stop()).called(1);
      });

      testWidgets('pauses, seeks, and plays the audio track', (tester) async {
        final controller = AudioPlayerController();

        await tester.pumpApp(
          AudioPlayer(
            audioAssetPath: 'audioAssetPath',
            controller: controller,
            child: child,
          ),
        );
        await controller.playAudio();

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
      testWidgets('calls stop on the audio player', (tester) async {
        final controller = AudioPlayerController();

        await tester.pumpApp(
          AudioPlayer(
            audioAssetPath: 'audioAssetPath',
            controller: controller,
            child: child,
          ),
        );
        await controller.stopAudio();

        verify(() => audioPlayer.stop()).called(1);
      });
    });

    group('dispose', () {
      testWidgets('calls dispose on the audio player', (tester) async {
        await tester.pumpApp(
          AudioPlayer(
            audioAssetPath: 'audioAssetPath',
            child: child,
          ),
        );
        await tester.pumpAndSettle();
        await tester.pumpWidget(Container());

        verify(() => audioPlayer.dispose()).called(1);
      });

      testWidgets('waits for playing to end before calling dispose',
          (tester) async {
        final completer = Completer<void>();
        final controller = AudioPlayerController();
        when(audioPlayer.play).thenAnswer((_) => completer.future);

        await tester.pumpApp(
          AudioPlayer(
            audioAssetPath: 'audioAssetPath',
            controller: controller,
            child: child,
          ),
        );
        await tester.pumpAndSettle();
        final playFuture = controller.playAudio();

        await tester.pumpWidget(Container());

        verifyNever(() => audioPlayer.dispose());

        completer.complete();
        await playFuture;
        await tester.pumpAndSettle();

        verify(() => audioPlayer.dispose()).called(1);
      });

      testWidgets('still disposes even when playing fails', (tester) async {
        final controller = AudioPlayerController();
        when(audioPlayer.play).thenThrow(Exception());

        await tester.pumpApp(
          AudioPlayer(
            audioAssetPath: 'audioAssetPath',
            controller: controller,
            child: child,
          ),
        );
        await tester.pumpAndSettle();
        final playFuture = controller.playAudio();

        await tester.pumpWidget(Container());
        await playFuture;
        await tester.pumpAndSettle();

        verify(() => audioPlayer.dispose()).called(1);
      });
    });

    group('listens to the mute sound bloc', () {
      testWidgets('sets the volume to 0 when muted', (tester) async {
        final muteSoundBloc = _MockMuteSoundBloc();
        whenListen(
          muteSoundBloc,
          Stream.fromIterable([
            MuteSoundState(isMuted: false),
            MuteSoundState(isMuted: true),
            MuteSoundState(isMuted: true),
          ]),
          initialState: MuteSoundState(isMuted: false),
        );
        await tester.pumpApp(
          AudioPlayer(
            audioAssetPath: 'audioAssetPath',
            child: child,
          ),
          muteSoundBloc: muteSoundBloc,
        );
        await tester.pumpAndSettle();

        verify(() => audioPlayer.setVolume(0)).called(1);
      });

      testWidgets('sets the volume to 1 when unmuted', (tester) async {
        final muteSoundBloc = _MockMuteSoundBloc();
        whenListen(
          muteSoundBloc,
          Stream.fromIterable([
            MuteSoundState(isMuted: true),
            MuteSoundState(isMuted: false),
            MuteSoundState(isMuted: false),
          ]),
          initialState: MuteSoundState(isMuted: true),
        );
        await tester.pumpApp(
          AudioPlayer(
            audioAssetPath: 'audioAssetPath',
            child: child,
          ),
          muteSoundBloc: muteSoundBloc,
        );
        await tester.pumpAndSettle();

        verify(() => audioPlayer.setVolume(1)).called(1);
      });
    });
  });
}
