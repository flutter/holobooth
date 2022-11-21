import 'package:example/assets/assets.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:screen_recorder/screen_recorder.dart';

class Dash extends StatefulWidget {
  const Dash({
    Key? key,
    required this.faceGeometry,
    required this.screenRecorderController,
  }) : super(key: key);

  final FaceGeometry faceGeometry;
  final ScreenRecorderController screenRecorderController;

  @override
  DashState createState() => DashState();
}

class DashState extends State<Dash> {
  _DashStateMachineController? _dashController;

  void _onRiveInit(Artboard artboard) {
    _dashController = _DashStateMachineController(artboard);
    artboard.addController(_dashController!);
  }

  @override
  void didUpdateWidget(covariant Dash oldWidget) {
    super.didUpdateWidget(oldWidget);

    final dashController = _dashController;
    if (dashController != null) {
      dashController.openMouth.change(widget.faceGeometry.mouth.isOpen);
      final direction = widget.faceGeometry.direction.value;
      _dashController?.x.change(
        -direction.x * ((_DashStateMachineController._xRange / 2) + 50),
      );
      _dashController?.y.change(
        direction.y * ((_DashStateMachineController._yRange / 2) + 50),
      );
    }
  }

  @override
  void dispose() {
    _dashController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenRecorder(
      width: 300,
      height: 300,
      controller: widget.screenRecorderController,
      child: Assets.dash.rive(
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
  late final SMIBool openMouth;
}
