import 'package:flutter/material.dart';
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

    final leftEye = testFindInput != null
        ? testFindInput(leftEyeInputName)
        : findInput<double>(leftEyeInputName);
    if (leftEye is SMINumber) {
      this.leftEye = leftEye;
    } else {
      throw StateError('Could not find input "$leftEyeInputName"');
    }

    final rightEye = testFindInput != null
        ? testFindInput(rightEyeInputName)
        : findInput<double>(rightEyeInputName);
    if (rightEye is SMINumber) {
      this.rightEye = rightEye;
    } else {
      throw StateError('Could not find input "$rightEyeInputName"');
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

  @visibleForTesting
  static const xInputName = 'x';
  @visibleForTesting
  static const yInputName = 'y';
  @visibleForTesting
  static const zInputName = 'z';
  @visibleForTesting
  static const mouthDistanceInputName = 'Mouth Open';
  @visibleForTesting
  static const leftEyeInputName = 'Eyelid LF';
  @visibleForTesting
  static const rightEyeInputName = 'Eyelid RT';
  @visibleForTesting
  static const hatsInputName = 'Hats';
  @visibleForTesting
  static const glassesInputName = 'Glasses';
  @visibleForTesting
  static const clothesInputName = 'Clothes';
  @visibleForTesting
  static const handheldLeftInputName = 'HandheldLeft';

  late final SMINumber x;
  late final SMINumber y;
  late final SMINumber z;
  late final SMINumber mouthDistance;
  late final SMINumber leftEye;
  late final SMINumber rightEye;
  late final SMINumber hats;
  late final SMINumber glasses;
  late final SMINumber clothes;
  late final SMINumber handheldlLeft;
}
