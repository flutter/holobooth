import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/rive/rive.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockInExperienceSelectionBloc
    extends MockBloc<InExperienceSelectionEvent, InExperienceSelectionState>
    implements InExperienceSelectionBloc {}

class _MockAvatarDetectorBloc
    extends MockBloc<AvatarDetectorEvent, AvatarDetectorState>
    implements AvatarDetectorBloc {}

void main() {
  group('PhotoboothCharacter', () {
    late InExperienceSelectionBloc inExperienceSelectionBloc;
    late AvatarDetectorBloc avatarDetectorBloc;
    setUp(() {
      inExperienceSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => inExperienceSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());

      avatarDetectorBloc = _MockAvatarDetectorBloc();
      when(() => avatarDetectorBloc.state).thenReturn(AvatarDetectorState());
    });

    testWidgets(
      'renders DashAnimation if dash selected',
      (WidgetTester tester) async {
        when(() => inExperienceSelectionBloc.state)
            .thenReturn(InExperienceSelectionState());
        await tester.pumpSubject(
          PhotoboothCharacter(),
          inExperienceSelectionBloc: inExperienceSelectionBloc,
          avatarDetectorBloc: avatarDetectorBloc,
        );
        expect(find.byType(DashAnimation), findsOneWidget);
      },
    );

    testWidgets(
      'renders SparkyAnimation if sparky selected',
      (WidgetTester tester) async {
        when(() => inExperienceSelectionBloc.state).thenReturn(
            InExperienceSelectionState(character: Character.sparky));
        await tester.pumpSubject(
          PhotoboothCharacter(),
          inExperienceSelectionBloc: inExperienceSelectionBloc,
          avatarDetectorBloc: avatarDetectorBloc,
        );
        expect(find.byType(SparkyAnimation), findsOneWidget);
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
