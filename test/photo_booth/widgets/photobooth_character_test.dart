import 'dart:async';

import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/avatar_detector/avatar_detector.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';
import 'package:holobooth/photo_booth/photo_booth.dart';
import 'package:holobooth/rive/rive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_helper/platform_helper.dart';

import '../../helpers/helpers.dart';

class _MockInExperienceSelectionBloc
    extends MockBloc<InExperienceSelectionEvent, InExperienceSelectionState>
    implements InExperienceSelectionBloc {}

class _MockAvatarDetectorBloc
    extends MockBloc<AvatarDetectorEvent, AvatarDetectorState>
    implements AvatarDetectorBloc {}

class _MockPlatformHelper extends Mock implements PlatformHelper {}

void main() {
  group('PhotoboothCharacter', () {
    late InExperienceSelectionBloc inExperienceSelectionBloc;
    late AvatarDetectorBloc avatarDetectorBloc;
    late PlatformHelper platformHelper;

    setUp(() {
      platformHelper = _MockPlatformHelper();

      inExperienceSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => inExperienceSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());

      avatarDetectorBloc = _MockAvatarDetectorBloc();
      when(() => avatarDetectorBloc.state).thenReturn(AvatarDetectorState());
    });

    testWidgets(
      'renders MobileDashCharacterAnimation if dash selected and it is mobile',
      (WidgetTester tester) async {
        when(() => inExperienceSelectionBloc.state)
            .thenReturn(InExperienceSelectionState());
        when(() => platformHelper.isMobile).thenReturn(true);

        await tester.pumpSubject(
          PhotoboothCharacter(platformHelper: platformHelper),
          inExperienceSelectionBloc: inExperienceSelectionBloc,
          avatarDetectorBloc: avatarDetectorBloc,
        );

        expect(
          find.byType(MobileDashCharacterAnimation),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders DesktopDashCharacterAnimation if dash selected and '
      'it is desktop',
      (WidgetTester tester) async {
        when(() => inExperienceSelectionBloc.state)
            .thenReturn(InExperienceSelectionState());
        when(() => platformHelper.isMobile).thenReturn(false);

        await tester.pumpSubject(
          PhotoboothCharacter(platformHelper: platformHelper),
          inExperienceSelectionBloc: inExperienceSelectionBloc,
          avatarDetectorBloc: avatarDetectorBloc,
        );

        expect(
          find.byType(DesktopDashCharacterAnimation),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders SparkyCharacterAnimation if sparky selected',
      (WidgetTester tester) async {
        when(() => inExperienceSelectionBloc.state).thenReturn(
          InExperienceSelectionState(character: Character.sparky),
        );
        await tester.pumpSubject(
          PhotoboothCharacter(),
          inExperienceSelectionBloc: inExperienceSelectionBloc,
          avatarDetectorBloc: avatarDetectorBloc,
        );

        expect(
          find.byType(SparkyCharacterAnimation),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'uses latest detected Avatar when not available',
      (WidgetTester tester) async {
        when(() => inExperienceSelectionBloc.state)
            .thenReturn(InExperienceSelectionState());
        final avatar1 = Avatar(
          hasMouthOpen: true,
          mouthDistance: 0.5,
          rotation: Vector3(0.5, 0.5, 0),
          distance: 0.8,
          leftEyeGeometry: LeftEyeGeometry.empty(),
          rightEyeGeometry: RightEyeGeometry.empty(),
        );
        final avatarStreamController = StreamController<AvatarDetectorState>();
        whenListen(
          avatarDetectorBloc,
          avatarStreamController.stream,
          initialState: AvatarDetectorState(
            status: AvatarDetectorStatus.detected,
            avatar: avatar1,
          ),
        );

        await tester.pumpSubject(
          PhotoboothCharacter(),
          inExperienceSelectionBloc: inExperienceSelectionBloc,
          avatarDetectorBloc: avatarDetectorBloc,
        );
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<MobileDashCharacterAnimation>(
                find.byType(MobileDashCharacterAnimation),
              )
              .avatar,
          equals(avatar1),
        );

        final avatar2 = Avatar(
          hasMouthOpen: false,
          mouthDistance: 0,
          rotation: Vector3(0.2, 0.8, 0),
          distance: 0.4,
          leftEyeGeometry: LeftEyeGeometry.empty(),
          rightEyeGeometry: RightEyeGeometry.empty(),
        );
        expect(avatar1, isNot(equals(avatar2)));
        avatarStreamController.sink.add(
          AvatarDetectorState(
            status: AvatarDetectorStatus.notDetected,
            avatar: avatar2,
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<MobileDashCharacterAnimation>(
                find.byType(MobileDashCharacterAnimation),
              )
              .avatar,
          equals(avatar1),
        );
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    PhotoboothCharacter subject, {
    required InExperienceSelectionBloc inExperienceSelectionBloc,
    required AvatarDetectorBloc avatarDetectorBloc,
  }) =>
      pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: inExperienceSelectionBloc),
            BlocProvider.value(value: avatarDetectorBloc),
          ],
          child: Scaffold(body: subject),
        ),
      );
}
