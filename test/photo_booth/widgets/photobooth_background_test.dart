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

void main() {
  group('PhotoboothBackground', () {
    late InExperienceSelectionBloc inExperienceSelectionBloc;

    setUp(() {
      inExperienceSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => inExperienceSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());
    });

    testWidgets(
      'renders for all backgrounds',
      (WidgetTester tester) async {
        for (final background in Background.values) {
          when(() => inExperienceSelectionBloc.state)
              .thenReturn(InExperienceSelectionState(background: background));
          await tester.pumpApp(
            BlocProvider.value(
              value: inExperienceSelectionBloc,
              child: PhotoboothBackground(),
            ),
          );
          expect(find.byKey(Key(background.name)), findsOneWidget);
        }
      },
    );
  });
}
