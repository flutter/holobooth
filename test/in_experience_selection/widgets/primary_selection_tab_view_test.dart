import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';
import 'package:holobooth/photo_booth/photo_booth.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockInExperienceSelectionBloc
    extends MockBloc<InExperienceSelectionEvent, InExperienceSelectionState>
    implements InExperienceSelectionBloc {}

class _MockPhotoBoothBloc extends MockBloc<PhotoBoothEvent, PhotoBoothState>
    implements PhotoBoothBloc {}

class _MockAudioPlayer extends Mock implements just_audio.AudioPlayer {}

void main() {
  setUpAll(() {
    registerFallbackValue(just_audio.LoopMode.all);
  });

  group('PropsSelectionTabBarView', () {
    late InExperienceSelectionBloc inExperienceSelectionBloc;
    late PhotoBoothBloc photoBoothBloc;
    late just_audio.AudioPlayer audioPlayer;

    setUp(() {
      inExperienceSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => inExperienceSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());

      photoBoothBloc = _MockPhotoBoothBloc();
      when(() => photoBoothBloc.state).thenReturn(PhotoBoothState());

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

    testWidgets(
      'does not render TabBarView if collapsed ',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          PrimarySelectionView(collapsed: true),
          inExperienceSelectionBloc,
          photoBoothBloc,
        );

        expect(
          find.byType(TabBarView),
          findsNothing,
        );
      },
    );

    testWidgets(
      'moves to BackgroundSelectionTabBarView clicking on NextButton '
      'on CharacterSelectionTabBarView',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          PrimarySelectionView(),
          inExperienceSelectionBloc,
          photoBoothBloc,
        );
        expect(find.byType(BackgroundSelectionTabBarView), findsNothing);
        await tester.tap(find.byType(NextButton));
        await tester.pumpAndSettle();
        expect(find.byType(BackgroundSelectionTabBarView), findsOneWidget);
      },
    );

    testWidgets(
      'plays sound when tapping on a tab',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          PrimarySelectionView(),
          inExperienceSelectionBloc,
          photoBoothBloc,
        );
        await tester.tap(find.byIcon(Icons.face));

        verify(() => audioPlayer.setAsset(Assets.audio.tabClick)).called(1);
        verify(audioPlayer.play).called(1);
      },
    );

    testWidgets(
      'moves to PropsSelectionTabBarView clicking on NextButton '
      'on BackgroundSelectionTabBarView',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          PrimarySelectionView(initialIndex: 1),
          inExperienceSelectionBloc,
          photoBoothBloc,
        );
        expect(find.byType(PropsSelectionTabBarView), findsNothing);
        await tester.tap(find.byType(NextButton));
        await tester.pumpAndSettle();
        expect(find.byType(PropsSelectionTabBarView), findsOneWidget);
      },
    );

    testWidgets(
      'adds PhotoBoothRecordingStarted clicking on RecordingButton '
      'on PropsSelectionTabBarView',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          PrimarySelectionView(initialIndex: 2),
          inExperienceSelectionBloc,
          photoBoothBloc,
        );
        await tester.tap(find.byType(RecordingButton));
        await tester.pumpAndSettle();
        verifyNever(() => photoBoothBloc.add(PhotoBoothRecordingStarted()));
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    PrimarySelectionView subject,
    InExperienceSelectionBloc inExperienceSelectionBloc,
    PhotoBoothBloc photoBoothBloc,
  ) =>
      pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: inExperienceSelectionBloc),
            BlocProvider.value(value: photoBoothBloc),
          ],
          child: Scaffold(
            body: subject,
          ),
        ),
      );
}
