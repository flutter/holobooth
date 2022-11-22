import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/props/props.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

class _MockInExperienceSelectionBloc
    extends MockBloc<InExperienceSelectionEvent, InExperienceSelectionState>
    implements InExperienceSelectionBloc {}

class _MockInExperienceSelectionBloc extends MockBloc<PropsEvent, PropsState>
    implements InExperienceSelectionBloc {}

void main() {
  group('DrawerLayer', () {
    late InExperienceSelectionBloc propsBloc;
    late InExperienceSelectionBloc drawerSelectionBloc;

    setUp(() {
      propsBloc = _MockInExperienceSelectionBloc();
      when(() => propsBloc.state).thenReturn(PropsState());
      drawerSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => drawerSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());
    });

    testWidgets('renders nothing if no option selected', (tester) async {
      await tester.pumpSubject(DrawerLayer(), drawerSelectionBloc, propsBloc);
      expect(find.byKey(DrawerLayer.noOptionSelectedKey), findsOneWidget);
    });

    testWidgets('renders props drawer if DrawerOption.props', (tester) async {
      when(() => drawerSelectionBloc.state).thenReturn(
        InExperienceSelectionState(drawerOption: DrawerOption.props),
      );
      await tester.pumpSubject(DrawerLayer(), drawerSelectionBloc, propsBloc);
      expect(find.byKey(DrawerLayer.propsDrawerKey), findsOneWidget);
    });

    testWidgets('renders backgrounds drawer if DrawerOption.backgrounds',
        (tester) async {
      when(() => drawerSelectionBloc.state).thenReturn(
        InExperienceSelectionState(drawerOption: DrawerOption.backgrounds),
      );
      await tester.pumpSubject(DrawerLayer(), drawerSelectionBloc, propsBloc);
      expect(find.byKey(DrawerLayer.backgroundsDrawerKey), findsOneWidget);
    });

    testWidgets('renders characters drawer if DrawerOption.characters',
        (tester) async {
      when(() => drawerSelectionBloc.state).thenReturn(
        InExperienceSelectionState(drawerOption: DrawerOption.characters),
      );
      await tester.pumpSubject(DrawerLayer(), drawerSelectionBloc, propsBloc);
      expect(find.byKey(DrawerLayer.charactersDrawerKey), findsOneWidget);
    });

    testWidgets('closes drawer after selecting prop', (tester) async {
      when(() => drawerSelectionBloc.state).thenReturn(
        InExperienceSelectionState(drawerOption: DrawerOption.props),
      );
      await tester.pumpSubject(DrawerLayer(), drawerSelectionBloc, propsBloc);
      const prop = Prop.helmet;
      await tester.tap(find.byKey(Key('${prop.name}_propSelection')));
      await tester.pumpAndSettle();
      expect(find.byType(DrawerLayer), findsNothing);
    });

    testWidgets('closes drawer after selecting background', (tester) async {
      when(() => drawerSelectionBloc.state).thenReturn(
        InExperienceSelectionState(drawerOption: DrawerOption.backgrounds),
      );
      await tester.pumpSubject(DrawerLayer(), drawerSelectionBloc, propsBloc);
      const background = PhotoboothColors.purple;
      await tester
          .tap(find.byKey(Key('${background.value}_backgroundSelection')));
      await tester.pumpAndSettle();
      expect(find.byType(DrawerLayer), findsNothing);
    });

    testWidgets('closes drawer after selecting character', (tester) async {
      when(() => drawerSelectionBloc.state).thenReturn(
        InExperienceSelectionState(drawerOption: DrawerOption.characters),
      );
      await tester.pumpSubject(DrawerLayer(), drawerSelectionBloc, propsBloc);
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
    InExperienceSelectionBloc drawerSelectionBloc,
    InExperienceSelectionBloc propsBloc,
  ) =>
      pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: drawerSelectionBloc),
            BlocProvider.value(value: propsBloc),
          ],
          child: subject,
        ),
      );
}
