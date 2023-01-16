import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/rive/rive.dart';
import 'package:rive/rive.dart';

class _FakeSMINumber extends Fake implements SMINumber {
  @override
  double get value => 0;
}

void main() {
  group('CharacterStateMachineController', () {
    final artboard = Artboard();
    const xInputName = CharacterStateMachineController.xInputName;
    const yInputName = CharacterStateMachineController.yInputName;
    const zInputName = CharacterStateMachineController.zInputName;
    const mouthDistanceInputName =
        CharacterStateMachineController.mouthDistanceInputName;
    const leftEyeIsClosedInputName =
        CharacterStateMachineController.leftEyeInputName;
    const rightEyeIsClosedInputName =
        CharacterStateMachineController.rightEyeInputName;
    const hatsInputName = CharacterStateMachineController.hatsInputName;
    const glassesInputName = CharacterStateMachineController.glassesInputName;
    const clothesInputName = CharacterStateMachineController.clothesInputName;
    const handheldLeftInputName =
        CharacterStateMachineController.handheldLeftInputName;

    test('throws StateError if X is missing', () {
      expect(
        () => CharacterStateMachineController(
          artboard,
          testFindInput: (name) => null,
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
        () => CharacterStateMachineController(
          artboard,
          testFindInput: (name) {
            if (name == xInputName) {
              return _FakeSMINumber();
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
        () => CharacterStateMachineController(
          artboard,
          testFindInput: (name) {
            if (name == xInputName || name == yInputName) {
              return _FakeSMINumber();
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

    test('throws StateError if Mouth Open is missing', () {
      expect(
        () => CharacterStateMachineController(
          artboard,
          testFindInput: (name) {
            if (name == xInputName ||
                name == yInputName ||
                name == zInputName) {
              return _FakeSMINumber();
            }
            if (name == mouthDistanceInputName) {
              return null;
            }
            return null;
          },
        ),
        throwsA(
          predicate(
            (e) =>
                e is StateError &&
                e.message == 'Could not find input "$mouthDistanceInputName"',
          ),
        ),
      );
    });

    test('throws StateError if $leftEyeIsClosedInputName is missing', () {
      expect(
        () => CharacterStateMachineController(
          artboard,
          testFindInput: (name) {
            if (name == xInputName ||
                name == yInputName ||
                name == zInputName ||
                name == mouthDistanceInputName) {
              return _FakeSMINumber();
            }
            if (name == leftEyeIsClosedInputName) {
              return null;
            }
            return null;
          },
        ),
        throwsA(
          predicate(
            (e) =>
                e is StateError &&
                e.message == 'Could not find input "$leftEyeIsClosedInputName"',
          ),
        ),
      );
    });

    test('throws StateError if $rightEyeIsClosedInputName is missing', () {
      expect(
        () => CharacterStateMachineController(
          artboard,
          testFindInput: (name) {
            if (name == xInputName ||
                name == yInputName ||
                name == zInputName ||
                name == mouthDistanceInputName ||
                name == leftEyeIsClosedInputName) {
              return _FakeSMINumber();
            }
            if (name == rightEyeIsClosedInputName) {
              return null;
            }
            return null;
          },
        ),
        throwsA(
          predicate(
            (e) =>
                e is StateError &&
                e.message ==
                    'Could not find input "$rightEyeIsClosedInputName"',
          ),
        ),
      );
    });

    test('throws StateError if $hatsInputName is missing', () {
      expect(
        () => CharacterStateMachineController(
          artboard,
          testFindInput: (name) {
            if (name == xInputName ||
                name == yInputName ||
                name == zInputName ||
                name == mouthDistanceInputName ||
                name == leftEyeIsClosedInputName ||
                name == rightEyeIsClosedInputName) {
              return _FakeSMINumber();
            }
            if (name == hatsInputName) {
              return null;
            }
            return null;
          },
        ),
        throwsA(
          predicate(
            (e) =>
                e is StateError &&
                e.message == 'Could not find input "$hatsInputName"',
          ),
        ),
      );
    });

    test('throws StateError if $glassesInputName is missing', () {
      expect(
        () => CharacterStateMachineController(
          artboard,
          testFindInput: (name) {
            if (name == xInputName ||
                name == yInputName ||
                name == zInputName ||
                name == mouthDistanceInputName ||
                name == leftEyeIsClosedInputName ||
                name == rightEyeIsClosedInputName ||
                name == hatsInputName) {
              return _FakeSMINumber();
            }
            if (name == glassesInputName) {
              return null;
            }
            return null;
          },
        ),
        throwsA(
          predicate(
            (e) =>
                e is StateError &&
                e.message == 'Could not find input "$glassesInputName"',
          ),
        ),
      );
    });

    test('throws StateError if $clothesInputName is missing', () {
      expect(
        () => CharacterStateMachineController(
          artboard,
          testFindInput: (name) {
            if (name == xInputName ||
                name == yInputName ||
                name == zInputName ||
                name == mouthDistanceInputName ||
                name == leftEyeIsClosedInputName ||
                name == rightEyeIsClosedInputName ||
                name == hatsInputName ||
                name == glassesInputName) {
              return _FakeSMINumber();
            }
            if (name == clothesInputName) {
              return null;
            }
            return null;
          },
        ),
        throwsA(
          predicate(
            (e) =>
                e is StateError &&
                e.message == 'Could not find input "$clothesInputName"',
          ),
        ),
      );
    });

    test('throws StateError if $handheldLeftInputName is missing', () {
      expect(
        () => CharacterStateMachineController(
          artboard,
          testFindInput: (name) {
            if (name == xInputName ||
                name == yInputName ||
                name == zInputName ||
                name == mouthDistanceInputName ||
                name == leftEyeIsClosedInputName ||
                name == rightEyeIsClosedInputName ||
                name == hatsInputName ||
                name == glassesInputName ||
                name == clothesInputName) {
              return _FakeSMINumber();
            }
            if (name == handheldLeftInputName) {
              return null;
            }
            return null;
          },
        ),
        throwsA(
          predicate(
            (e) =>
                e is StateError &&
                e.message == 'Could not find input "$handheldLeftInputName"',
          ),
        ),
      );
    });
  });
}
