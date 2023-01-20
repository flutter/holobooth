// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/animoji_intro/view/animoji_intro_page.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth/landing/landing.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockAudioPlayer extends Mock implements just_audio.AudioPlayer {}

void main() {
  setUpAll(() {
    registerFallbackValue(just_audio.LoopMode.all);
  });

  group('LandingPage', () {
    testWidgets('renders landing view', (tester) async {
      await tester.pumpApp(const LandingPage());
      expect(find.byType(LandingView), findsOneWidget);
    });
  });

  group('LandingView', () {
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

    testWidgets('renders background', (tester) async {
      await tester.pumpApp(const LandingView());
      expect(find.byType(LandingBackground), findsOneWidget);
    });

    testWidgets('renders heading', (tester) async {
      await tester.pumpApp(const LandingView());

      final l10n = tester.element(find.byType(LandingView)).l10n;

      expect(find.text(l10n.landingPageHeading), findsOneWidget);
    });

    testWidgets('renders image', (tester) async {
      await tester.pumpApp(const LandingView());
      expect(find.byKey(LandingBody.landingPageImageKey), findsOneWidget);
    });

    testWidgets('renders image on small screens', (tester) async {
      tester.setDisplaySize(const Size(HoloboothBreakpoints.small, 1000));
      await tester.pumpApp(const LandingView());
      expect(find.byKey(LandingBody.landingPageImageKey), findsOneWidget);
    });

    testWidgets('renders subheading', (tester) async {
      await tester.pumpApp(const LandingView());
      expect(find.byKey(Key('landingPage_subheading_text')), findsOneWidget);
    });

    testWidgets('renders take photo button', (tester) async {
      await tester.pumpApp(const LandingView());
      expect(find.byType(LandingTakePhotoButton), findsOneWidget);
    });

    testWidgets('tapping on take photo button navigates to AnimojiIntroPage',
        (tester) async {
      await tester.pumpApp(const LandingView());
      await tester.ensureVisible(find.byType(LandingTakePhotoButton));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byType(
          LandingTakePhotoButton,
          skipOffstage: false,
        ),
      );
      await tester.pump(kThemeAnimationDuration);
      await tester.pump(kThemeAnimationDuration);
      await tester.pump(kThemeAnimationDuration);

      expect(find.byType(AnimojiIntroPage), findsOneWidget);
      expect(find.byType(LandingView), findsNothing);
    });
  });
}
