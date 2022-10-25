import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:rive/rive.dart';

class DashAnimation extends StatefulWidget {
  const DashAnimation({
    super.key,
    required this.avatar,
  });

  final Avatar avatar;

  @override
  State<DashAnimation> createState() => _DashAnimationState();
}

class _DashAnimationState extends State<DashAnimation> {
  _DashStateMachineController? _dashController;

  void _onRiveInit(Artboard artboard) {
    _dashController = _DashStateMachineController(artboard);
    artboard.addController(_dashController!);
  }

  @override
  void didUpdateWidget(covariant DashAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    final dashController = _dashController;
    if (dashController != null) {
      final direction = widget.avatar.direction.unit();
      dashController.x.change(direction.x * 1000);
      dashController.y.change(direction.y * -1000);

      dashController.openMouth.change(widget.avatar.hasMouthOpen);
    }
  }

  @override
  void dispose() {
    _dashController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Assets.characters.dash.rive(
        onInit: _onRiveInit,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _DashStateMachineController extends StateMachineController {
  _DashStateMachineController(Artboard artboard)
      : super(
          artboard.animations
              .whereType<StateMachine>()
              .firstWhere((stateMachine) => stateMachine.name == 'dash'),
        ) {
    final x = findInput<double>('x');
    if (x is SMINumber) {
      this.x = x;
    } else {
      throw StateError('Could not find input "x"');
    }

    final y = findInput<double>('y');
    if (y is SMINumber) {
      this.y = y;
    } else {
      throw StateError('Could not find input "y"');
    }

    final openMouth = findInput<bool>('openMouth');
    if (openMouth is SMIBool) {
      this.openMouth = openMouth;
    } else {
      throw StateError('Could not find input "openMouth"');
    }
  }

  late final SMINumber x;
  late final SMINumber y;
  late final SMIBool openMouth;
}
