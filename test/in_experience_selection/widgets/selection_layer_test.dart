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
  group('SelectionLayer', () {
    late InExperienceSelectionBloc inExperienceSelectionBloc;

    setUp(() {
      inExperienceSelectionBloc = _MockInExperienceSelectionBloc();
      when(() => inExperienceSelectionBloc.state)
          .thenReturn(InExperienceSelectionState());
    });

    testWidgets(
      'renders MobileSelectionLayer on mobile breakpoint',
      (tester) async {
        tester.setPortraitDisplaySize();
        await tester.pumpSubject(SelectionLayer(), inExperienceSelectionBloc);
        expect(find.byType(MobileSelectionLayer), findsOneWidget);
      },
    );

    testWidgets(
      'renders DesktopSelectionLayer on breakpoint different than mobile',
      (tester) async {
        tester.setLandscapeDisplaySize();
        await tester.pumpSubject(SelectionLayer(), inExperienceSelectionBloc);
        expect(find.byType(DesktopSelectionLayer), findsOneWidget);
      },
    );

    testWidgets(
      'collapse layout clicking CollapseButton on mobile breakpoint',
      (tester) async {
        tester.setPortraitDisplaySize();
        await tester.pumpSubject(SelectionLayer(), inExperienceSelectionBloc);
        expect(
          find.byKey(PrimarySelectionView.primaryTabBarViewKey),
          findsOneWidget,
        );
        await tester.tap(find.byType(CollapseButton));
        await tester.pumpAndSettle();
        expect(
          find.byKey(PrimarySelectionView.primaryTabBarViewKey),
          findsNothing,
        );
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    SelectionLayer subject,
    InExperienceSelectionBloc inExperienceSelectionBloc,
  ) =>
      pumpApp(
        BlocProvider.value(
          value: inExperienceSelectionBloc,
          child: Scaffold(body: Stack(children: [subject])),
        ),
      );
}
