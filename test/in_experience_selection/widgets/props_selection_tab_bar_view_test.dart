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
        await tester.pumpAndSettle();

        final finder = find.byKey(PropsSelectionTabBarView.glassesTabKey);
        expect(finder, findsOneWidget);
        await tester.tap(finder);
        await tester.pumpAndSettle();
        expect(find.byType(GlassesSelectionTabBarView), findsOneWidget);
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
