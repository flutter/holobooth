import 'package:rive/rive.dart';

class CharacterStateMachineController extends StateMachineController {
  CharacterStateMachineController(
    Artboard artboard, {
    SMIInput<dynamic>? Function(String name)? testFindInput,
  }) : super(
          testFindInput == null
              ? artboard.animations.whereType<StateMachine>().firstWhere(
                    (stateMachine) => stateMachine.name == 'State Machine 1',
                  )
              : StateMachine(),
        ) {
    final x = testFindInput != null
        ? testFindInput(xInputName)
        : findInput<double>(xInputName);
    if (x is SMINumber) {
      this.x = x;
    } else {
      throw StateError('Could not find input "$xInputName"');
    }

    final y = testFindInput != null
        ? testFindInput(yInputName)
        : findInput<double>(yInputName);
    if (y is SMINumber) {
      this.y = y;
    } else {
      throw StateError('Could not find input "$yInputName"');
    }

    final z = testFindInput != null
        ? testFindInput(zInputName)
        : findInput<double>(zInputName);
    if (z is SMINumber) {
      this.z = z;
    } else {
      throw StateError('Could not find input "$zInputName"');
    }

    final mouthDistance = testFindInput != null
        ? testFindInput(mouthDistanceInputName)
        : findInput<double>(mouthDistanceInputName);
    if (mouthDistance is SMINumber) {
      this.mouthDistance = mouthDistance;
    } else {
      throw StateError('Could not find input "$mouthDistanceInputName"');
    }

    final leftEyeIsClosed = testFindInput != null
        ? testFindInput(leftEyeIsClosedInputName)
        : findInput<double>(leftEyeIsClosedInputName);
    if (leftEyeIsClosed is SMINumber) {
      this.leftEyeIsClosed = leftEyeIsClosed;
    } else {
      throw StateError('Could not find input "$leftEyeIsClosedInputName"');
    }

    final rightEyeIsClosed = testFindInput != null
        ? testFindInput(rightEyeIsClosedInputName)
        : findInput<double>(rightEyeIsClosedInputName);
    if (rightEyeIsClosed is SMINumber) {
      this.rightEyeIsClosed = rightEyeIsClosed;
    } else {
      throw StateError('Could not find input "$rightEyeIsClosedInputName"');
    }

    final hats = testFindInput != null
        ? testFindInput(hatsInputName)
        : findInput<double>(hatsInputName);
    if (hats is SMINumber) {
      this.hats = hats;
    } else {
      throw StateError('Could not find input "$hatsInputName"');
    }

    final glasses = testFindInput != null
        ? testFindInput(glassesInputName)
        : findInput<double>(glassesInputName);
    if (glasses is SMINumber) {
      this.glasses = glasses;
    } else {
      throw StateError('Could not find input "$glassesInputName"');
    }

    final clothes = testFindInput != null
        ? testFindInput(clothesInputName)
        : findInput<double>(clothesInputName);
    if (clothes is SMINumber) {
      this.clothes = clothes;
    } else {
      throw StateError('Could not find input "$clothesInputName"');
    }

    final handheldlLeft = testFindInput != null
        ? testFindInput(handheldLeftInputName)
        : findInput<double>(handheldLeftInputName);
    if (handheldlLeft is SMINumber) {
      this.handheldlLeft = handheldlLeft;
    } else {
      throw StateError('Could not find input "$handheldLeftInputName"');
    }
  }

  static const xInputName = 'x';
  static const yInputName = 'y';
  static const zInputName = 'z';
  static const mouthDistanceInputName = 'Mouth Open';
  static const leftEyeIsClosedInputName = 'Eyelid LF';
  static const rightEyeIsClosedInputName = 'Eyelid RT';
  static const hatsInputName = 'Hats';
  static const glassesInputName = 'Glasses';
  static const clothesInputName = 'Clothes';
  static const handheldLeftInputName = 'HandheldLeft';

  late final SMINumber x;
  late final SMINumber y;
  late final SMINumber z;
  late final SMINumber mouthDistance;
  late final SMINumber leftEyeIsClosed;
  late final SMINumber rightEyeIsClosed;
  late final SMINumber hats;
  late final SMINumber glasses;
  late final SMINumber clothes;
  late final SMINumber handheldlLeft;
}
// coverage:ignore-end
