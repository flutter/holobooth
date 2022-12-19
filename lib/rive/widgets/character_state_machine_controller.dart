import 'package:rive/rive.dart';

// TODO(oscar): remove on the scope of this task https://very-good-ventures-team.monday.com/boards/3161754080/pulses/3428762748
// coverage:ignore-start
class CharacterStateMachineController extends StateMachineController {
  CharacterStateMachineController(Artboard artboard)
      : super(
          artboard.animations.whereType<StateMachine>().firstWhere(
                (stateMachine) => stateMachine.name == 'State Machine 1',
              ),
        ) {
    const xInputName = 'x';
    final x = findInput<double>(xInputName);
    if (x is SMINumber) {
      this.x = x;
    } else {
      throw StateError('Could not find input "$xInputName"');
    }

    const yInputName = 'y';
    final y = findInput<double>(yInputName);
    if (y is SMINumber) {
      this.y = y;
    } else {
      throw StateError('Could not find input "$yInputName"');
    }

    const zInputName = 'z';
    final z = findInput<double>(zInputName);
    if (z is SMINumber) {
      this.z = z;
    } else {
      throw StateError('Could not find input "$zInputName"');
    }

    const mouthDistanceInputName = 'Mouth Open';
    final mouthDistance = findInput<double>(mouthDistanceInputName);
    if (mouthDistance is SMINumber) {
      this.mouthDistance = mouthDistance;
    } else {
      throw StateError('Could not find input "$mouthDistanceInputName"');
    }

    const leftEyeIsClosedInputName = 'Eyelid LF';
    final leftEyeIsClosed = findInput<double>(leftEyeIsClosedInputName);
    if (leftEyeIsClosed is SMINumber) {
      this.leftEyeIsClosed = leftEyeIsClosed;
    } else {
      throw StateError('Could not find input "$leftEyeIsClosedInputName"');
    }

    const rightEyeIsClosedInputName = 'Eyelid RT';
    final rightEyeIsClosed = findInput<double>(rightEyeIsClosedInputName);
    if (rightEyeIsClosed is SMINumber) {
      this.rightEyeIsClosed = rightEyeIsClosed;
    } else {
      throw StateError('Could not find input "$rightEyeIsClosedInputName"');
    }

    const hatsInputName = 'Hats';
    final hats = findInput<double>(hatsInputName);
    if (hats is SMINumber) {
      this.hats = hats;
    } else {
      throw StateError('Could not find input "$hatsInputName"');
    }

    const glassesInputName = 'Glasses';
    final glasses = findInput<double>(glassesInputName);
    if (glasses is SMINumber) {
      this.glasses = glasses;
    } else {
      throw StateError('Could not find input "$glassesInputName"');
    }

    const clothesInputName = 'Clothes';
    final clothes = findInput<double>(clothesInputName);
    if (clothes is SMINumber) {
      this.clothes = clothes;
    } else {
      throw StateError('Could not find input "$clothesInputName"');
    }

    const handheldLeftInputName = 'HandheldLeft';
    final handheldlLeft = findInput<double>(handheldLeftInputName);
    if (handheldlLeft is SMINumber) {
      this.handheldlLeft = handheldlLeft;
    } else {
      throw StateError('Could not find input "$handheldLeftInputName"');
    }
  }

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
