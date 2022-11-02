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
    if (dashController != null) {
      final direction = widget.avatar.direction.unit();
      dashController!.x.change(direction.x * 1000);
      dashController!.y.change(direction.y * -1000);
      dashController!.openMouth.change(widget.avatar.hasMouthOpen);
    }
  }

  @override
  void dispose() {
    dashController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Assets.animations.dash.rive(
        onInit: _onRiveInit,
        fit: BoxFit.cover,
      ),
    );
  }
}

@visibleForTesting
class DashStateMachineController extends StateMachineController {
  DashStateMachineController(
    Artboard artboard, {
    SMIInput<dynamic>? Function(String name)? testFindInput,
  }) : super(
          testFindInput == null
              ? artboard.animations
                  .whereType<StateMachine>()
                  .firstWhere((stateMachine) => stateMachine.name == 'dash')
              : StateMachine(),
        ) {
    final x =
        testFindInput != null ? testFindInput('x') : findInput<double>('x');
    if (x is SMINumber) {
      this.x = x;
    } else {
      throw StateError('Could not find input "x"');
    }

    final y =
        testFindInput != null ? testFindInput('y') : findInput<double>('y');
    if (y is SMINumber) {
      this.y = y;
    } else {
      throw StateError('Could not find input "y"');
    }

    final openMouth = testFindInput != null
        ? testFindInput('openMouth')
        : findInput<bool>('openMouth');
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
