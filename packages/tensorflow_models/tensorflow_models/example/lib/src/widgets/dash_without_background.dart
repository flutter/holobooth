import 'package:example/assets/assets.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:screen_recorder/screen_recorder.dart';

class DashWithoutBackground extends StatefulWidget {
  const DashWithoutBackground({
    Key? key,
    required this.faceGeometry,
    required this.screenRecorderController,
  }) : super(key: key);

  final FaceGeometry faceGeometry;
  final ScreenRecorderController screenRecorderController;

  @override
  DashWithoutBackgroundState createState() => DashWithoutBackgroundState();
}

class DashWithoutBackgroundState extends State<DashWithoutBackground> {
  _DashStateMachineController? _dashController;

  void _onRiveInit(Artboard artboard) {
    _dashController = _DashStateMachineController(artboard);
    artboard.addController(_dashController!);
  }

  @override
  void didUpdateWidget(covariant DashWithoutBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    final dashController = _dashController;
    if (dashController != null) {
      dashController.helmet.change(true);
      dashController.openMouth.change(widget.faceGeometry.mouth.isOpen);
      dashController.leftEyeClosed.change(widget.faceGeometry.leftEye.isClosed);
      dashController.rightEyeClosed
          .change(widget.faceGeometry.rightEye.isClosed);
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
      width: 440,
      height: 440,
      controller: widget.screenRecorderController,
      child: SizedBox(
        width: 300,
        height: 300,
        child: Assets.dashWithBackground.rive(
          onInit: _onRiveInit,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _DashStateMachineController extends StateMachineController {
  _DashStateMachineController(Artboard artboard)
      : super(
          artboard.animations.whereType<StateMachine>().firstWhere(
                (stateMachine) => stateMachine.name == 'State Machine 1',
              ),
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

    final openMouth = findInput<bool>('MouthisOpen');
    if (openMouth is SMIBool) {
      this.openMouth = openMouth;
    } else {
      throw StateError('Could not find input "MouthisOpen"');
    }

    final leftEyeClosed = findInput<bool>('Left Eye Wink');
    if (leftEyeClosed is SMIBool) {
      this.leftEyeClosed = leftEyeClosed;
    } else {
      throw StateError('Could not find input "Left Eye Wink"');
    }

    final rightEyeClosed = findInput<bool>('Right Eye Wink');
    if (rightEyeClosed is SMIBool) {
      this.rightEyeClosed = rightEyeClosed;
    } else {
      throw StateError('Could not find input "Right Eye Wink"');
    }

    final helmet = findInput<bool>('helmet');
    if (helmet is SMIBool) {
      this.helmet = helmet;
    } else {
      throw StateError('Could not find input "helmet"');
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
  late final SMIBool leftEyeClosed;
  late final SMIBool rightEyeClosed;
  late final SMIBool helmet;
}
