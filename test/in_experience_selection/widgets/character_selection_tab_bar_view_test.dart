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
  group('CharacterSelectionTabBarView', () {
    late InExperienceSelectionBloc inExperienceSelectionBloc;

    setUp(() {
      inExperienceSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => inExperienceSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());
    });

    testWidgets(
      'adds InExperienceSelectionCharacterSelected clicking on a character',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          CharacterSelectionTabBarView(onNextPressed: () {}),
          inExperienceSelectionBloc,
        );
        await tester.pumpAndSettle();
        const character = Character.dash;
        await tester.tap(
          find.byKey(Key('characterSelectionElement_${character.name}')),
        );
        verify(
          () => inExperienceSelectionBloc
              .add(InExperienceSelectionCharacterSelected(character)),
        ).called(1);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    CharacterSelectionTabBarView subject,
    InExperienceSelectionBloc inExperienceSelectionBloc,
  ) =>
      pumpApp(
        BlocProvider.value(
          value: inExperienceSelectionBloc,
          child: Scaffold(body: subject),
        ),
      );
}
