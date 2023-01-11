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
        const background = Background.bg01;
        final finder = find.byKey(
          BackgroundSelectionTabBarView.backgroundSelectionKey(background),
        );
        await tester.tap(finder);
        await tester.pumpAndSettle();
        verify(
          () => inExperienceSelectionBloc
              .add(InExperienceSelectionBackgroundSelected(background)),
        ).called(1);
      },
    );

    testWidgets(
      'renders every background',
      (WidgetTester tester) async {
        tester.setLargeDisplaySize();

        await tester.pumpSubject(
          BackgroundSelectionTabBarView(),
          inExperienceSelectionBloc,
        );
        for (final background in Background.values) {
          await tester.drag(
            find.byKey(BackgroundSelectionTabBarView.listviewKey),
            Offset(0, -50),
          );
          await tester.pumpAndSettle();
          expect(
            find.byKey(
              BackgroundSelectionTabBarView.backgroundSelectionKey(background),
            ),
            findsOneWidget,
          );
        }
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
          child: Scaffold(
            body: SizedBox(width: 200, height: 500, child: subject),
          ),
        ),
      );
}
