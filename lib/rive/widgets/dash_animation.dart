import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
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
class DashAnimationState extends State<DashAnimation>
    with TickerProviderStateMixin {
  @visibleForTesting
  DashStateMachineController? dashController;

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 50),
  );

  final Tween<Offset> _tween = Tween(begin: Offset.zero, end: Offset.zero);

  static const _distanceToleration = 3;

  void _onRiveInit(Artboard artboard) {
    dashController = DashStateMachineController(artboard);
    artboard.addController(dashController!);
    _animationController.addListener(_controlDashPosition);
  }

  void _controlDashPosition() {
    final dashController = this.dashController;
    if (dashController != null) {
      final offset = _tween.evaluate(_animationController);
      dashController.x.change(offset.dx);
      dashController.y.change(offset.dy);
    }
  }

  @override
  void didUpdateWidget(covariant DashAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    final dashController = this.dashController;
    if (dashController != null) {
      // Dash movement
      final previousOffset =
          Offset(dashController.x.value, dashController.y.value);
      final newOffset = Offset(
        widget.avatar.direction.x * 100,
        widget.avatar.direction.y * 100,
      );
      if ((newOffset - previousOffset).distance > _distanceToleration) {
        _tween
          ..begin = previousOffset
          ..end = newOffset;
        _animationController.forward(from: 0);
      }

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

  late final SMINumber x;
  late final SMINumber y;
  late final SMIBool mouthIsOpen;
  late final SMIBool leftEyeIsClosed;
  late final SMIBool rightEyeIsClosed;
  late final SMIBool displayHelmet;
}
// coverage:ignore-end
