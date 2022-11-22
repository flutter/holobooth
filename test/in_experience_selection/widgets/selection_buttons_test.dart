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
  group('SelectionButtons', () {
    late InExperienceSelectionBloc drawerSelectionBloc;
    late InExperienceSelectionBloc propsBloc;

    setUp(() {
      drawerSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => drawerSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());

      propsBloc = _MockInExperienceSelectionBloc();
      when(() => propsBloc.state).thenReturn(PropsState());
    });

    testWidgets(
      'adds InExperienceSelectionOptionSelected with DrawerOption.props '
      'clicking on props button',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          SelectionButtons(),
          drawerSelectionBloc,
          propsBloc,
        );
        await tester.tap(find.byKey(SelectionButtons.propsSelectionButtonKey));
        verify(
          () => drawerSelectionBloc.add(
            InExperienceSelectionOptionSelected(
              drawerOption: DrawerOption.props,
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'adds InExperienceSelectionOptionSelected with DrawerOption.characters '
      'clicking on characters button',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          SelectionButtons(),
          drawerSelectionBloc,
          propsBloc,
        );
        await tester
            .tap(find.byKey(SelectionButtons.charactersSelectionButtonKey));
        verify(
          () => drawerSelectionBloc.add(
            InExperienceSelectionOptionSelected(
              drawerOption: DrawerOption.characters,
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'adds InExperienceSelectionOptionSelected with DrawerOption.background '
      'clicking on background button',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          SelectionButtons(),
          drawerSelectionBloc,
          propsBloc,
        );
        await tester
            .tap(find.byKey(SelectionButtons.backgroundSelectorButtonKey));
        verify(
          () => drawerSelectionBloc.add(
            InExperienceSelectionOptionSelected(
              drawerOption: DrawerOption.backgrounds,
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
        'shows the characters bottomSheet when screen width is smaller '
        'than mobile breakpoint', (tester) async {
      whenListen(
        drawerSelectionBloc,
        Stream.value(
          InExperienceSelectionState(drawerOption: DrawerOption.characters),
        ),
      );
      tester.setSmallDisplaySize();
      await tester.pumpSubject(
        SelectionButtons(),
        drawerSelectionBloc,
        propsBloc,
      );
      await tester.pumpAndSettle();
      expect(find.byType(ItemSelectorBottomSheet<Color>), findsOneWidget);
      expect(
        find.byKey(SelectionButtons.characterSelectionBottomSheetKey),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows the backgrounds bottomSheet when screen width is smaller '
        'than mobile breakpoint', (tester) async {
      whenListen(
        drawerSelectionBloc,
        Stream.value(
          InExperienceSelectionState(drawerOption: DrawerOption.backgrounds),
        ),
      );
      tester.setSmallDisplaySize();
      await tester.pumpSubject(
        SelectionButtons(),
        drawerSelectionBloc,
        propsBloc,
      );
      await tester.pumpAndSettle();
      expect(find.byType(ItemSelectorBottomSheet<Color>), findsOneWidget);
      expect(
        find.byKey(SelectionButtons.backgroundSelectionBottomSheetKey),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows the props bottomSheet when screen width is smaller '
        'than mobile breakpoint', (tester) async {
      whenListen(
        drawerSelectionBloc,
        Stream.value(
          InExperienceSelectionState(drawerOption: DrawerOption.props),
        ),
      );
      tester.setSmallDisplaySize();
      await tester.pumpSubject(
        SelectionButtons(),
        drawerSelectionBloc,
        propsBloc,
      );
      await tester.pumpAndSettle();
      expect(find.byType(ItemSelectorBottomSheet<Prop>), findsOneWidget);
      expect(
        find.byKey(SelectionButtons.propsSelectionBottomSheetKey),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows the characters drawer when screen width is greater '
        'than mobile breakpoint', (tester) async {
      whenListen(
        drawerSelectionBloc,
        Stream.value(
          InExperienceSelectionState(drawerOption: DrawerOption.characters),
        ),
      );
      await tester.pumpSubject(
        SelectionButtons(),
        drawerSelectionBloc,
        propsBloc,
      );
      await tester.pumpAndSettle();

      expect(find.byType(DrawerLayer), findsOneWidget);
      expect(find.byKey(DrawerLayer.charactersDrawerKey), findsOneWidget);
    });

    testWidgets(
        'shows the props drawer when screen width is greater '
        'than mobile breakpoint', (tester) async {
      whenListen(
        drawerSelectionBloc,
        Stream.value(
          InExperienceSelectionState(drawerOption: DrawerOption.props),
        ),
      );
      await tester.pumpSubject(
        SelectionButtons(),
        drawerSelectionBloc,
        propsBloc,
      );
      await tester.pumpAndSettle();

      expect(find.byType(DrawerLayer), findsOneWidget);
      expect(find.byKey(DrawerLayer.propsDrawerKey), findsOneWidget);
    });

    testWidgets(
        'shows the backgrounds drawer when screen width is greater '
        'than mobile breakpoint', (tester) async {
      whenListen(
        drawerSelectionBloc,
        Stream.value(
          InExperienceSelectionState(drawerOption: DrawerOption.backgrounds),
        ),
      );
      await tester.pumpSubject(
        SelectionButtons(),
        drawerSelectionBloc,
        propsBloc,
      );
      await tester.pumpAndSettle();

      expect(find.byType(DrawerLayer), findsOneWidget);
      expect(find.byKey(DrawerLayer.backgroundsDrawerKey), findsOneWidget);
    });

    testWidgets(
        'adds InExperienceSelectionPropSelected on props bottom sheet after clicking on any item '
        'on mobile breakpoint', (tester) async {
      whenListen(
        drawerSelectionBloc,
        Stream.value(
          InExperienceSelectionState(drawerOption: DrawerOption.props),
        ),
      );
      tester.setSmallDisplaySize();
      await tester.pumpSubject(
        SelectionButtons(),
        drawerSelectionBloc,
        propsBloc,
      );
      await tester.pumpAndSettle();
      const prop = Prop.helmet;
      await tester.tap(find.byKey(Key('${prop.name}_propSelection')));
      await tester.pumpAndSettle();
      verify(() => propsBloc.add(InExperienceSelectionPropSelected(prop)))
          .called(1);
    });

    testWidgets(
        'adds InExperienceSelectionOptionUnselected after closing bottom sheet '
        'on mobile breakpoint', (tester) async {
      whenListen(
        drawerSelectionBloc,
        Stream.value(
          InExperienceSelectionState(drawerOption: DrawerOption.props),
        ),
      );
      tester.setSmallDisplaySize();
      await tester.pumpSubject(
        SelectionButtons(),
        drawerSelectionBloc,
        propsBloc,
      );
      await tester.pumpAndSettle();
      const prop = Prop.helmet;
      await tester.tap(find.byKey(Key('${prop.name}_propSelection')));
      await tester.pumpAndSettle();
      verify(
        () => drawerSelectionBloc.add(InExperienceSelectionOptionUnselected()),
      ).called(1);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    SelectionButtons subject,
    InExperienceSelectionBloc drawerSelectionBloc,
    InExperienceSelectionBloc propsBloc,
  ) =>
      pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: drawerSelectionBloc),
            BlocProvider.value(value: propsBloc),
          ],
          child: Scaffold(
            endDrawer: DrawerLayer(),
            body: subject,
          ),
        ),
      );
}
