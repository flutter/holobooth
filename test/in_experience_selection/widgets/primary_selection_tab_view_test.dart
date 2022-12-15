import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockInExperienceSelectionBloc
    extends MockBloc<InExperienceSelectionEvent, InExperienceSelectionState>
    implements InExperienceSelectionBloc {}

class _MockPhotoBoothBloc extends MockBloc<PhotoBoothEvent, PhotoBoothState>
    implements PhotoBoothBloc {}

void main() {
  group('PropsSelectionTabBarView', () {
    late InExperienceSelectionBloc inExperienceSelectionBloc;
    late PhotoBoothBloc photoBoothBloc;

    setUp(() {
      inExperienceSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => inExperienceSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());

      photoBoothBloc = _MockPhotoBoothBloc();
      when(() => photoBoothBloc.state).thenReturn(PhotoBoothState.empty());
    });

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
        verify(() => photoBoothBloc.add(PhotoBoothRecordingStarted()))
            .called(1);
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
