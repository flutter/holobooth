import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/animoji_intro/animoji_intro.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/audio_player/audio_player.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  setUpAll(() {
    registerFallbackValue(LoopMode.all);
  });

  late AudioPlayer audioPlayer;

  setUp(() {
    audioPlayer = _MockAudioPlayer();

    when(audioPlayer.pause).thenAnswer((_) async {});
    when(audioPlayer.play).thenAnswer((_) async {});
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

  group('AnimojiIntroPage', () {
    testWidgets('renders AnimojiIntroView', (tester) async {
      await tester.pumpApp(AnimojiIntroPage());
      expect(find.byType(AnimojiIntroView), findsOneWidget);
    });
  });

  group('AnimojiIntroView', () {
    testWidgets('renders background', (tester) async {
      await tester.pumpApp(const AnimojiIntroView());
      expect(find.byType(AnimojiIntroBackground), findsOneWidget);
    });

    testWidgets('plays audio', (tester) async {
      await tester.pumpApp(const AnimojiIntroView());
      await tester.pumpAndSettle();

      verify(() => audioPlayer.setAsset(Assets.audio.landingPageAmbient))
          .called(1);
      verify(audioPlayer.play).called(1);
    });

    testWidgets('renders subheading', (tester) async {
      await tester.pumpApp(const AnimojiIntroView());
      expect(find.byKey(Key('animojiIntro_subheading_text')), findsOneWidget);
    });

    testWidgets('renders next button', (tester) async {
      await tester.pumpApp(const AnimojiIntroView());
      expect(find.byType(NextButton), findsOneWidget);
    });

    testWidgets('tapping on next button navigates to PhotoBoothPage',
        (tester) async {
      await tester.pumpApp(const AnimojiIntroView());
      await tester.ensureVisible(find.byType(NextButton));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byType(
          NextButton,
          skipOffstage: false,
        ),
      );
      await tester.pump(kThemeAnimationDuration);
      await tester.pump(kThemeAnimationDuration);
      await tester.pump(kThemeAnimationDuration);

      expect(find.byType(PhotoBoothPage), findsOneWidget);
      expect(find.byType(AnimojiIntroPage), findsNothing);
    });
  });
}
