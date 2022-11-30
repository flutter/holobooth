import 'package:alchemist/alchemist.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

class _MockInExperienceSelectionBloc
    extends MockBloc<InExperienceSelectionEvent, InExperienceSelectionState>
    implements InExperienceSelectionBloc {}

class _SubjectBuilder extends StatelessWidget {
  const _SubjectBuilder({required this.widget});

  final SelectionButtons Function(BuildContext) widget;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.fromWindow(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Localizations(
          locale: Locale('en'),
          delegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          child: Theme(
            data: PhotoboothTheme.standard,
            child: SizedBox.fromSize(
              size: Size(300, 600),
              child: Builder(builder: widget),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  group('SelectionButtons', () {
    late InExperienceSelectionBloc inExperienceSelectionBloc;

    setUp(() {
      inExperienceSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => inExperienceSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());
    });

    testWidgets(
      'adds InExperienceSelectionOptionSelected with DrawerOption.props '
      'clicking on props button',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          SelectionButtons(),
          inExperienceSelectionBloc,
        );
        await tester.tap(find.byKey(SelectionButtons.propsSelectionButtonKey));
        verify(
          () => inExperienceSelectionBloc.add(
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
          inExperienceSelectionBloc,
        );
        await tester
            .tap(find.byKey(SelectionButtons.charactersSelectionButtonKey));
        verify(
          () => inExperienceSelectionBloc.add(
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
          inExperienceSelectionBloc,
        );
        await tester
            .tap(find.byKey(SelectionButtons.backgroundSelectorButtonKey));
        verify(
          () => inExperienceSelectionBloc.add(
            InExperienceSelectionOptionSelected(
              drawerOption: DrawerOption.backgrounds,
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
        'shows the characters bottomSheet when screen width is smaller '
        'than mobile breakpoint and DrawerOption.characters', (tester) async {
      whenListen(
        inExperienceSelectionBloc,
        Stream.value(
          InExperienceSelectionState(drawerOption: DrawerOption.characters),
        ),
      );
      tester.setSmallDisplaySize();
      await tester.pumpSubject(
        SelectionButtons(),
        inExperienceSelectionBloc,
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
        'than mobile breakpoint and DrawerOption.backgrounds', (tester) async {
      whenListen(
        inExperienceSelectionBloc,
        Stream.value(
          InExperienceSelectionState(drawerOption: DrawerOption.backgrounds),
        ),
      );
      tester.setSmallDisplaySize();
      await tester.pumpSubject(
        SelectionButtons(),
        inExperienceSelectionBloc,
      );
      await tester.pumpAndSettle();
      expect(find.byType(ItemSelectorBottomSheet<Background>), findsOneWidget);
      expect(
        find.byKey(SelectionButtons.backgroundSelectionBottomSheetKey),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows the props bottomSheet when screen width is smaller '
        'than mobile breakpoint and DrawerOption.props', (tester) async {
      whenListen(
        inExperienceSelectionBloc,
        Stream.value(
          InExperienceSelectionState(drawerOption: DrawerOption.props),
        ),
      );
      tester.setSmallDisplaySize();
      await tester.pumpSubject(
        SelectionButtons(),
        inExperienceSelectionBloc,
      );
      await tester.pumpAndSettle();
      expect(find.byType(ItemSelectorBottomSheet<Prop>), findsOneWidget);
      expect(
        find.byKey(SelectionButtons.propsSelectionBottomSheetKey),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows the drawer when screen width is greater '
        'than mobile breakpoint', (tester) async {
      whenListen(
        inExperienceSelectionBloc,
        Stream.value(
          InExperienceSelectionState(drawerOption: DrawerOption.characters),
        ),
      );
      await tester.pumpSubject(
        SelectionButtons(),
        inExperienceSelectionBloc,
      );
      await tester.pumpAndSettle();

      expect(find.byType(DrawerLayer), findsOneWidget);
      expect(find.byKey(DrawerLayer.charactersDrawerKey), findsOneWidget);
    });

    testWidgets(
        'adds InExperienceSelectionPropSelected on props bottom sheet '
        'after clicking on any item ', (tester) async {
      whenListen(
        inExperienceSelectionBloc,
        Stream.value(
          InExperienceSelectionState(drawerOption: DrawerOption.props),
        ),
      );
      tester.setSmallDisplaySize();
      await tester.pumpSubject(
        SelectionButtons(),
        inExperienceSelectionBloc,
      );
      await tester.pumpAndSettle();
      const prop = Prop.helmet;
      await tester.tap(find.byKey(Key('${prop.name}_propSelection')));
      await tester.pumpAndSettle();
      verify(
        () => inExperienceSelectionBloc
            .add(InExperienceSelectionPropSelected(prop)),
      ).called(1);
    });

    testWidgets(
        'adds InExperienceSelectionBackgroundSelected on '
        'background bottom sheet '
        'after clicking on any item ', (tester) async {
      whenListen(
        inExperienceSelectionBloc,
        Stream.value(
          InExperienceSelectionState(drawerOption: DrawerOption.backgrounds),
        ),
      );
      tester.setSmallDisplaySize();
      await tester.pumpSubject(
        SelectionButtons(),
        inExperienceSelectionBloc,
      );
      await tester.pumpAndSettle();
      const background = Background.forest;
      await tester
          .tap(find.byKey(Key('${background.name}_backgroundSelection')));
      await tester.pumpAndSettle();
      verify(
        () => inExperienceSelectionBloc
            .add(InExperienceSelectionBackgroundSelected(background)),
      ).called(1);
    });

    testWidgets(
        'adds InExperienceSelectionOptionSelected with DrawerOption null '
        'after closing bottom sheet '
        'on mobile breakpoint', (tester) async {
      whenListen(
        inExperienceSelectionBloc,
        Stream.value(
          InExperienceSelectionState(drawerOption: DrawerOption.props),
        ),
      );
      tester.setSmallDisplaySize();
      await tester.pumpSubject(
        SelectionButtons(),
        inExperienceSelectionBloc,
      );
      await tester.pumpAndSettle();
      const prop = Prop.helmet;
      await tester.tap(find.byKey(Key('${prop.name}_propSelection')));
      await tester.pumpAndSettle();
      verify(
        () => inExperienceSelectionBloc.add(
          InExperienceSelectionOptionSelected(),
        ),
      ).called(1);
    });

    goldenTest(
      'renders prop button on SelectionButtons',
      fileName: 'selection_buttons_props',
      pumpBeforeTest: precacheImages,
      builder: () {
        return GoldenTestGroup(
          children: [
            GoldenTestScenario(
              name: 'no props selected',
              child: Builder(
                builder: (context) {
                  when(() => inExperienceSelectionBloc.state)
                      .thenReturn(InExperienceSelectionState());
                  return BlocProvider.value(
                    value: inExperienceSelectionBloc,
                    child: _SubjectBuilder(widget: (_) => SelectionButtons()),
                  );
                },
              ),
            ),
            GoldenTestScenario(
              name: 'one prop selected',
              child: Builder(
                builder: (context) {
                  when(() => inExperienceSelectionBloc.state).thenReturn(
                    InExperienceSelectionState(
                      selectedProps: const [Prop.helmet],
                    ),
                  );
                  return BlocProvider.value(
                    value: inExperienceSelectionBloc,
                    child: _SubjectBuilder(widget: (_) => SelectionButtons()),
                  );
                },
              ),
            ),
            GoldenTestScenario(
              name: 'more than one prop selected',
              child: Builder(
                builder: (context) {
                  when(() => inExperienceSelectionBloc.state).thenReturn(
                    InExperienceSelectionState(
                      selectedProps: const [Prop.helmet, Prop.helmet],
                    ),
                  );
                  return BlocProvider.value(
                    value: inExperienceSelectionBloc,
                    child: _SubjectBuilder(widget: (_) => SelectionButtons()),
                  );
                },
              ),
            ),
          ],
        );
      },
    );

    goldenTest(
      'renders background button on SelectionButtons',
      fileName: 'selection_buttons_background',
      pumpBeforeTest: precacheImages,
      builder: () {
        return GoldenTestGroup(
          children: [
            GoldenTestScenario(
              name: 'space',
              child: Builder(
                builder: (context) {
                  when(() => inExperienceSelectionBloc.state)
                      .thenReturn(InExperienceSelectionState());
                  return BlocProvider.value(
                    value: inExperienceSelectionBloc,
                    child: _SubjectBuilder(widget: (_) => SelectionButtons()),
                  );
                },
              ),
            ),
            GoldenTestScenario(
              name: 'forest',
              child: Builder(
                builder: (context) {
                  when(() => inExperienceSelectionBloc.state).thenReturn(
                    InExperienceSelectionState(background: Background.forest),
                  );
                  return BlocProvider.value(
                    value: inExperienceSelectionBloc,
                    child: _SubjectBuilder(widget: (_) => SelectionButtons()),
                  );
                },
              ),
            ),
          ],
        );
      },
    );

    goldenTest(
      'renders character button on SelectionButtons',
      fileName: 'selection_buttons_character',
      pumpBeforeTest: precacheImages,
      builder: () {
        return GoldenTestGroup(
          children: [
            GoldenTestScenario(
              name: 'dash',
              child: Builder(
                builder: (context) {
                  when(() => inExperienceSelectionBloc.state)
                      .thenReturn(InExperienceSelectionState());
                  return BlocProvider.value(
                    value: inExperienceSelectionBloc,
                    child: _SubjectBuilder(widget: (_) => SelectionButtons()),
                  );
                },
              ),
            ),
            GoldenTestScenario(
              name: 'sparky',
              child: Builder(
                builder: (context) {
                  when(() => inExperienceSelectionBloc.state).thenReturn(
                    InExperienceSelectionState(character: Character.sparky),
                  );
                  return BlocProvider.value(
                    value: inExperienceSelectionBloc,
                    child: _SubjectBuilder(widget: (_) => SelectionButtons()),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    SelectionButtons subject,
    InExperienceSelectionBloc inExperienceSelectionBloc,
  ) =>
      pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: inExperienceSelectionBloc),
          ],
          child: Scaffold(
            endDrawer: DrawerLayer(),
            body: subject,
          ),
        ),
      );
}
