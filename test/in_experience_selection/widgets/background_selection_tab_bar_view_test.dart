import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockInExperienceSelectionBloc
    extends MockBloc<InExperienceSelectionEvent, InExperienceSelectionState>
    implements InExperienceSelectionBloc {}

void main() {
  group('BackgroundSelectionTabBarView', () {
    late InExperienceSelectionBloc inExperienceSelectionBloc;

    setUp(() {
      inExperienceSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => inExperienceSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());
    });

    testWidgets(
      'adds InExperienceSelectionBackgroundSelected clicking on a background',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          BackgroundSelectionTabBarView(),
          inExperienceSelectionBloc,
        );
        const background = Background.beach;
        final finder =
            find.byKey(Key('backgroundSelectionElement_${background.name}'));
        await tester.scrollUntilVisible(finder, 50);
        await tester.pumpAndSettle();
        await tester.tap(finder);
        await tester.pumpAndSettle();
        verify(
          () => inExperienceSelectionBloc
              .add(InExperienceSelectionBackgroundSelected(background)),
        ).called(1);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    BackgroundSelectionTabBarView subject,
    InExperienceSelectionBloc inExperienceSelectionBloc,
  ) =>
      pumpApp(
        BlocProvider.value(
          value: inExperienceSelectionBloc,
          child: Scaffold(body: subject),
        ),
      );
}
