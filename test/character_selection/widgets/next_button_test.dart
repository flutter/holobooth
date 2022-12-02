import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCharacterSelectionBloc
    extends MockBloc<CharacterSelectionEvent, Character>
    implements CharacterSelectionBloc {}

void main() {
  group('NextButton', () {
    late CharacterSelectionBloc characterSelectionBloc;
    setUp(() {
      characterSelectionBloc = _MockCharacterSelectionBloc();
      when(() => characterSelectionBloc.state).thenReturn(Character.dash);
    });

    testWidgets('navigates to PhotoBoothPage on tap', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: characterSelectionBloc,
          child: NextButton(),
        ),
      );
      await tester.tap(find.byType(NextButton));
      await tester.pump(kThemeAnimationDuration);
      await tester.pump(kThemeAnimationDuration);
      expect(find.byType(PhotoBoothPage), findsOneWidget);
    });
  });
}
