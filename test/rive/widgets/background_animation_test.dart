import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/rive/rive.dart';
import 'package:rive/rive.dart';

class _FakeNumber extends Fake implements SMINumber {
  @override
  double get value => 0;
}

void main() {
  group('BackgroundAnimation', () {
    testWidgets('can update background', (tester) async {
      late StateSetter stateSetter;
      var background = Background.space;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return BackgroundAnimation(backgroundSelected: background);
            },
          ),
        ),
      );

      final state = tester.state(find.byType(BackgroundAnimation))
          as BackgroundAnimationState;
      final controller = state.backgroundController!;

      final backgroundValue = controller.background.value;

      stateSetter(() {
        background = Background.underwater;
      });

      await tester.pump(Duration(milliseconds: 150));
      await tester.pump(Duration(milliseconds: 150));

      expect(controller.background.value, isNot(equals(backgroundValue)));
      await tester.pump(kThemeAnimationDuration);
    });
  });

  group('BackgroundAnimationStateMachineController', () {
    final artboard = Artboard();
    const xInputName = 'X';
    const yInputName = 'Y';
    const zInputName = 'Z';
    const backgroundInputName = 'BG';

    test('throws StateError if X is missing', () {
      expect(
        () => BackgroundAnimationStateMachineController(
          artboard,
          testFindInput: (name) {
            if (name == xInputName) {
              return null;
            }
            return null;
          },
        ),
        throwsA(
          predicate(
            (e) =>
                e is StateError &&
                e.message == 'Could not find input "$xInputName"',
          ),
        ),
      );
    });

    test('throws StateError if Y is missing', () {
      expect(
        () => BackgroundAnimationStateMachineController(
          artboard,
          testFindInput: (name) {
            if (name == xInputName) {
              return _FakeNumber();
            }
            if (name == yInputName) {
              return null;
            }
            return null;
          },
        ),
        throwsA(
          predicate(
            (e) =>
                e is StateError &&
                e.message == 'Could not find input "$yInputName"',
          ),
        ),
      );
    });

    test('throws StateError if Z is missing', () {
      expect(
        () => BackgroundAnimationStateMachineController(
          artboard,
          testFindInput: (name) {
            if (name == xInputName || name == yInputName) {
              return _FakeNumber();
            }
            if (name == zInputName) {
              return null;
            }
            return null;
          },
        ),
        throwsA(
          predicate(
            (e) =>
                e is StateError &&
                e.message == 'Could not find input "$zInputName"',
          ),
        ),
      );
    });

    test('throws StateError if BG is missing', () {
      expect(
        () => BackgroundAnimationStateMachineController(
          artboard,
          testFindInput: (name) {
            if (name == xInputName ||
                name == yInputName ||
                name == zInputName) {
              return _FakeNumber();
            }
            if (name == backgroundInputName) {
              return null;
            }
            return null;
          },
        ),
        throwsA(
          predicate(
            (e) =>
                e is StateError &&
                e.message == 'Could not find input "$backgroundInputName"',
          ),
        ),
      );
    });
  });
}
