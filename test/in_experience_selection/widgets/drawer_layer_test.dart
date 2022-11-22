import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

class _MockInExperienceSelectionBloc
    extends MockBloc<InExperienceSelectionEvent, InExperienceSelectionState>
    implements InExperienceSelectionBloc {}

void main() {
  group('DrawerLayer', () {
    late InExperienceSelectionBloc inExperienceSelectionBloc;

    setUp(() {
      inExperienceSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => inExperienceSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());
    });

    testWidgets('renders nothing if no option selected', (tester) async {
      await tester.pumpSubject(
        DrawerLayer(),
        inExperienceSelectionBloc,
      );
      expect(find.byKey(DrawerLayer.noOptionSelectedKey), findsOneWidget);
    });

    testWidgets('renders props drawer if DrawerOption.props', (tester) async {
      when(() => inExperienceSelectionBloc.state).thenReturn(
        InExperienceSelectionState(drawerOption: DrawerOption.props),
      );
      await tester.pumpSubject(
        DrawerLayer(),
        inExperienceSelectionBloc,
      );
      expect(find.byKey(DrawerLayer.propsDrawerKey), findsOneWidget);
    });

    testWidgets('renders backgrounds drawer if DrawerOption.backgrounds',
        (tester) async {
      when(() => inExperienceSelectionBloc.state).thenReturn(
        InExperienceSelectionState(drawerOption: DrawerOption.backgrounds),
      );
      await tester.pumpSubject(
        DrawerLayer(),
        inExperienceSelectionBloc,
      );
      expect(find.byKey(DrawerLayer.backgroundsDrawerKey), findsOneWidget);
    });

    testWidgets('renders characters drawer if DrawerOption.characters',
        (tester) async {
      when(() => inExperienceSelectionBloc.state).thenReturn(
        InExperienceSelectionState(drawerOption: DrawerOption.characters),
      );
      await tester.pumpSubject(
        DrawerLayer(),
        inExperienceSelectionBloc,
      );
      expect(find.byKey(DrawerLayer.charactersDrawerKey), findsOneWidget);
    });

    testWidgets('closes drawer after selecting prop', (tester) async {
      when(() => inExperienceSelectionBloc.state).thenReturn(
        InExperienceSelectionState(drawerOption: DrawerOption.props),
      );
      await tester.pumpSubject(
        DrawerLayer(),
        inExperienceSelectionBloc,
      );
      const prop = Prop.helmet;
      await tester.tap(find.byKey(Key('${prop.name}_propSelection')));
      await tester.pumpAndSettle();
      expect(find.byType(DrawerLayer), findsNothing);
    });

    testWidgets('closes drawer after selecting background', (tester) async {
      when(() => inExperienceSelectionBloc.state).thenReturn(
        InExperienceSelectionState(drawerOption: DrawerOption.backgrounds),
      );
      await tester.pumpSubject(
        DrawerLayer(),
        inExperienceSelectionBloc,
      );
      const background = Background.forest;
      await tester
          .tap(find.byKey(Key('${background.name}_backgroundSelection')));
      await tester.pumpAndSettle();
      expect(find.byType(DrawerLayer), findsNothing);
    });

    testWidgets('closes drawer after selecting character', (tester) async {
      when(() => inExperienceSelectionBloc.state).thenReturn(
        InExperienceSelectionState(drawerOption: DrawerOption.characters),
      );
      await tester.pumpSubject(
        DrawerLayer(),
        inExperienceSelectionBloc,
      );
      const character = PhotoboothColors.orange;
      await tester
          .tap(find.byKey(Key('${character.value}_characterSelection')));
      await tester.pumpAndSettle();
      expect(find.byType(DrawerLayer), findsNothing);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    DrawerLayer subject,
    InExperienceSelectionBloc inExperienceSelectionBloc,
  ) =>
      pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: inExperienceSelectionBloc),
          ],
          child: subject,
        ),
      );
}
