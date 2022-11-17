import 'package:camera/camera.dart';
import 'package:example/assets/assets.dart';
import 'package:example/src/src.dart';
import 'package:example/src/widgets/dash_with_background.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LandmarksDashPage extends StatelessWidget {
  const LandmarksDashPage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LandmarksDashPage());

  @override
  Widget build(BuildContext context) => const _LandmarksDashView();
}

class _LandmarksDashView extends StatefulWidget {
  const _LandmarksDashView({Key? key}) : super(key: key);

  @override
  State<_LandmarksDashView> createState() => _LandmarksDashViewState();
}

class _LandmarksDashViewState extends State<_LandmarksDashView> {
  CameraController? _cameraController;
  FaceGeometry? _faceGeometry;
  bool _displayDashBackground = true;

  void _onCameraReady(CameraController cameraController) {
    setState(() => _cameraController = cameraController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            _displayDashBackground = !_displayDashBackground;
          });
        },
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0,
            child: CameraView(onCameraReady: _onCameraReady),
          ),
          if (_cameraController != null) ...[
            FacesDetectorBuilder(
              cameraController: _cameraController!,
              builder: (context, faces) {
                if (faces.isEmpty) {
                  if (_faceGeometry == null) {
                    return const SizedBox();
                  }
                } else {
                  final face = faces.first;
                  _faceGeometry = _faceGeometry == null
                      ? FaceGeometry.fromFace(face)
                      : _faceGeometry!.update(face);
                }

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_displayDashBackground)
                      DashWithBackground(faceGeometry: _faceGeometry)
                    else
                      Center(child: _Dash(faceGeometry: _faceGeometry!)),
                    FaceGeometryOverlay(faceGeometry: _faceGeometry!),
                  ],
                );
              },
            ),
          ]
        ],
      ),
    );
  }
}

class _Dash extends StatefulWidget {
  const _Dash({
    Key? key,
    required this.faceGeometry,
  }) : super(key: key);

  final FaceGeometry faceGeometry;

  @override
  _DashState createState() => _DashState();
}

class _DashState extends State<_Dash> {
  _DashStateMachineController? _dashController;

  void _onRiveInit(Artboard artboard) {
    _dashController = _DashStateMachineController(artboard);
    artboard.addController(_dashController!);
  }

  @override
  void didUpdateWidget(covariant _Dash oldWidget) {
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
    return SizedBox(
      width: 300,
      height: 300,
      child: Assets.dashWithBackground.rive(
        onInit: _onRiveInit,
        fit: BoxFit.cover,
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
