import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/props/props.dart';
import 'package:rive/rive.dart';

extension on List<Prop> {
  bool get isHelmetSelected => contains(Prop.helmet);
}

class DashAnimation extends StatefulWidget {
  const DashAnimation({
    super.key,
    required this.avatar,
    required this.propsSelected,
  });

  final Avatar avatar;
  final List<Prop> propsSelected;

  @override
  State<DashAnimation> createState() => DashAnimationState();
}

@visibleForTesting
class DashAnimationState extends State<DashAnimation> {
  @visibleForTesting
  DashStateMachineController? dashController;

  void _onRiveInit(Artboard artboard) {
    dashController = DashStateMachineController(artboard);
    artboard.addController(dashController!);
  }

  @override
  void didUpdateWidget(covariant DashAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    final dashController = this.dashController;
    if (dashController != null) {
      final direction = widget.avatar.direction;
      dashController.x.change(
        direction.x * ((DashStateMachineController._xRange / 2) + 50),
      );
      dashController.y.change(
        direction.y * ((DashStateMachineController._yRange / 2) + 50),
      );

      dashController.mouthIsOpen.change(widget.avatar.hasMouthOpen);
      dashController.rightEyeIsClosed.change(widget.avatar.rightEyeIsClosed);
      dashController.leftEyeIsClosed.change(widget.avatar.leftEyeIsClosed);

      dashController.displayHelmet.change(
        widget.propsSelected.isHelmetSelected,
      );
    }
  }

  @override
  void dispose() {
    dashController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Assets.animations.dash.rive(
      onInit: _onRiveInit,
      fit: BoxFit.cover,
    );
  }
}

// TODO(oscar): remove on the scope of this task https://very-good-ventures-team.monday.com/boards/3161754080/pulses/3428762748
// coverage:ignore-start
@visibleForTesting
class DashStateMachineController extends StateMachineController {
  DashStateMachineController(Artboard artboard)
      : super(
          artboard.animations
              .whereType<StateMachine>()
              .firstWhere((stateMachine) => stateMachine.name == 'dash'),
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

    const mouthIsOpenInputName = 'mouthIsOpen';
    final mouthIsOpen = findInput<bool>(mouthIsOpenInputName);
    if (mouthIsOpen is SMIBool) {
      this.mouthIsOpen = mouthIsOpen;
    } else {
      throw StateError('Could not find input "$mouthIsOpenInputName"');
    }

    const leftEyeIsClosedInputName = 'leftEyeIsClosed';
    final leftEyeIsClosed = findInput<bool>(leftEyeIsClosedInputName);
    if (leftEyeIsClosed is SMIBool) {
      this.leftEyeIsClosed = leftEyeIsClosed;
    } else {
      throw StateError('Could not find input "$leftEyeIsClosedInputName"');
    }

    const rightEyeIsClosedInputName = 'rightEyeIsClosed';
    final rightEyeIsClosed = findInput<bool>(rightEyeIsClosedInputName);
    if (rightEyeIsClosed is SMIBool) {
      this.rightEyeIsClosed = rightEyeIsClosed;
    } else {
      throw StateError('Could not find input "$rightEyeIsClosedInputName"');
    }

    const helmetInputName = 'helmet';
    final displayHelmet = findInput<bool>(helmetInputName);
    if (displayHelmet is SMIBool) {
      this.displayHelmet = displayHelmet;
    } else {
      throw StateError('Could not find input "$helmetInputName"');
    }
  }

  /// The total range [x] animates over.
  ///
  /// This data comes from the Rive file.
  static const _xRange = 200;

  /// The total range [y] animates over.
  ///
  /// This data comes from the Rive file.
  static const _yRange = 200;

  late final SMINumber x;
  late final SMINumber y;
  late final SMIBool mouthIsOpen;
  late final SMIBool leftEyeIsClosed;
  late final SMIBool rightEyeIsClosed;
  late final SMIBool displayHelmet;
}
// coverage:ignore-end
