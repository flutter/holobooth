import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CharacterSelector', () {
    group('renders characters', () {
      testWidgets('successfully for Breakpoint.small', (tester) async {
        await tester.pumpSubject(CharacterSelector(viewportFraction: 0.55));
        expect(find.byType(CharacterSelector), findsOneWidget);
        for (final characterKey in CharacterSelectorState.characterKeys) {
          expect(find.byKey(characterKey), findsOneWidget);
        }
      });

      testWidgets('successfully for Breakpoint.medium', (tester) async {
        await tester.pumpSubject(CharacterSelector(viewportFraction: 0.3));
        expect(find.byType(CharacterSelector), findsOneWidget);
        for (final characterKey in CharacterSelectorState.characterKeys) {
          expect(find.byKey(characterKey), findsOneWidget);
        }
      });

      testWidgets('successfully for Breakpoint.large', (tester) async {
        await tester.pumpSubject(CharacterSelector(viewportFraction: 0.2));
        expect(find.byType(CharacterSelector), findsOneWidget);
        for (final characterKey in CharacterSelectorState.characterKeys) {
          expect(find.byKey(characterKey), findsOneWidget);
        }
      });
    });

    testWidgets(
      'navigates to sparky on tap',
      (WidgetTester tester) async {
        await tester.pumpSubject(CharacterSelector(viewportFraction: 0.2));
        await tester.tap(find.byKey(CharacterSelectorState.sparkyKey));
        await tester.pumpAndSettle();
        final state = tester
            .state<CharacterSelectorState>(find.byType(CharacterSelector));
        final controller = state.pageController;
        expect(controller?.page, 1);
      },
    );

    testWidgets('updates viewportFraction if needed', (tester) async {
      late StateSetter stateSetter;
      var viewPortFraction = 0.55;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return Scaffold(
                body: CharacterSelector(viewportFraction: viewPortFraction),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final state =
          tester.state<CharacterSelectorState>(find.byType(CharacterSelector));

      expect(
        state.pageController?.viewportFraction,
        viewPortFraction,
      );
      stateSetter(() => viewPortFraction = 1);
      await tester.pumpAndSettle();
      expect(
        state.pageController?.viewportFraction,
        viewPortFraction,
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
