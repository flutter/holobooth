import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CharacterSelector', () {
    group('renders', () {
      testWidgets('successfully for Breakpoint.small', (tester) async {
        await tester
            .pumpSubject(CharacterSelector(breakpoint: Breakpoint.small));
        expect(find.byType(CharacterSelector), findsOneWidget);
      });

      testWidgets('successfully for Breakpoint.medium', (tester) async {
        await tester
            .pumpSubject(CharacterSelector(breakpoint: Breakpoint.medium));
        expect(find.byType(CharacterSelector), findsOneWidget);
      });

      testWidgets('successfully for Breakpoint.large', (tester) async {
        await tester
            .pumpSubject(CharacterSelector(breakpoint: Breakpoint.large));
        expect(find.byType(CharacterSelector), findsOneWidget);
      });

      testWidgets('successfully for Breakpoint.xLarge', (tester) async {
        await tester
            .pumpSubject(CharacterSelector(breakpoint: Breakpoint.xLarge));
        expect(find.byType(CharacterSelector), findsOneWidget);
      });
    });

    testWidgets(
      'navigates to sparky on tap',
      (WidgetTester tester) async {
        await tester
            .pumpSubject(CharacterSelector(breakpoint: Breakpoint.xLarge));
        await tester.tap(find.byKey(CharacterSelectorState.sparkyKey));
        await tester.pumpAndSettle();
        final state = tester
            .state<CharacterSelectorState>(find.byType(CharacterSelector));
        final controller = state.pageController;
        expect(controller.page, 1);
      },
    );

    testWidgets('updates viewportFraction if needed', (tester) async {
      late StateSetter stateSetter;
      var breakpoint = Breakpoint.small;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return Scaffold(
                body: CharacterSelector(breakpoint: breakpoint),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester
            .state<CharacterSelectorState>(find.byType(CharacterSelector))
            .pageController
            .viewportFraction,
        0.55,
      );
      stateSetter(() => breakpoint = Breakpoint.large);
      await tester.pumpAndSettle();
      expect(
        tester
            .state<CharacterSelectorState>(find.byType(CharacterSelector))
            .pageController
            .viewportFraction,
        0.2,
      );
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    CharacterSelector subject,
  ) {
    return pumpApp(Scaffold(body: subject));
  }
}
