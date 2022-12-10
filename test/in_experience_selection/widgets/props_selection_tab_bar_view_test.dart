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
  group('PropsSelectionTabBarView', () {
    late InExperienceSelectionBloc inExperienceSelectionBloc;

    setUp(() {
      inExperienceSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => inExperienceSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());
    });

    testWidgets(
      'display HatsSelectionTabBarView by default',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          PropsSelectionTabBarView(),
          inExperienceSelectionBloc,
        );
        expect(find.byType(HatsSelectionTabBarView), findsOneWidget);
      },
    );

    testWidgets(
      'display GlassesSelectionTabBarView by tapping on glasses tab',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          PropsSelectionTabBarView(),
          inExperienceSelectionBloc,
        );
        final finder = find.byKey(PropsSelectionTabBarView.glassesTabKey);
        expect(finder, findsOneWidget);
        await tester.tap(finder);
        await tester.pumpAndSettle();
        expect(find.byType(GlassesSelectionTabBarView), findsOneWidget);
      },
    );

    testWidgets(
      'display ClothesSelectionTabBarView by tapping on clothes tab',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          PropsSelectionTabBarView(),
          inExperienceSelectionBloc,
        );
        final finder = find.byKey(PropsSelectionTabBarView.clothesTabKey);
        expect(finder, findsOneWidget);
        await tester.tap(finder);
        await tester.pumpAndSettle();
        expect(find.byType(ClothesSelectionTabBarView), findsOneWidget);
      },
    );

    testWidgets(
      'adds InExperienceSelectionHatSelected tapping on a hat',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          PropsSelectionTabBarView(),
          inExperienceSelectionBloc,
        );
        const hat = Hats.helmet;
        await tester.tap(find.byKey(Key('hat_selection_${hat.name}')));
        verify(
          () => inExperienceSelectionBloc
              .add(InExperienceSelectionHatSelected(hat)),
        ).called(1);
      },
    );

    testWidgets(
      'adds InExperienceSelectionGlassesSelected tapping on a glasses',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          PropsSelectionTabBarView(initialIndex: 1),
          inExperienceSelectionBloc,
        );
        const glasses = Glasses.glasses1;
        await tester.tap(find.byKey(Key('glasses_selection_${glasses.name}')));
        verify(
          () => inExperienceSelectionBloc
              .add(InExperienceSelectionGlassesSelected(glasses)),
        ).called(1);
      },
    );

    testWidgets(
      'adds InExperienceSelectionClothesSelected tapping on a clothes',
      (WidgetTester tester) async {
        await tester.pumpSubject(
          PropsSelectionTabBarView(initialIndex: 2),
          inExperienceSelectionBloc,
        );
        const clothes = Clothes.clothes1;
        await tester.tap(find.byKey(Key('clothes_selection_${clothes.name}')));
        verify(
          () => inExperienceSelectionBloc
              .add(InExperienceSelectionClothesSelected(clothes)),
        ).called(1);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    PropsSelectionTabBarView subject,
    InExperienceSelectionBloc inExperienceSelectionBloc,
  ) =>
      pumpApp(
        MultiBlocProvider(
          providers: [BlocProvider.value(value: inExperienceSelectionBloc)],
          child: Scaffold(
            body: subject,
          ),
        ),
      );
}
