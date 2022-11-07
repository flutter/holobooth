import 'package:camera/camera.dart';
import 'package:example/assets/assets.dart';
import 'package:example/src/src.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

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
  var _isCameraVisible = false;

  void _onCameraReady(CameraController cameraController) {
    setState(() => _cameraController = cameraController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AspectRatio(
        aspectRatio: _cameraController?.value.aspectRatio ?? 1,
        child: Stack(
          children: [
            Opacity(
              opacity: _isCameraVisible ? 1 : 0,
              child: CameraView(onCameraReady: _onCameraReady),
            ),
            if (_cameraController != null) ...[
              FacesDetectorBuilder(
                cameraController: _cameraController!,
                builder: (context, faces) {
                  if (faces.isEmpty) return const SizedBox.shrink();
                  final face = FaceGeometry.fromFace(faces.first);

                  final cos = face.direction.newValues;
                  final direction = face.direction.value;

                  return Column(
                    children: [
                      Center(
                        child: _Dash(face: faces.first),
                      ),
                      Text(
                        'current vert ${cos[0].toStringAsFixed(2)} hor ${cos[1].toStringAsFixed(2)}',
                      ),
                      Text(
                        'org vert ${direction.y.toStringAsFixed(2)} hor ${direction.x.toStringAsFixed(2)}',
                      ),
                    ],
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isCameraVisible = !_isCameraVisible;
                    });
                  },
                  child: Text(
                    _isCameraVisible ? 'Hide the camera' : 'Show the camera',
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}

class _Dash extends StatefulWidget {
  const _Dash({
    Key? key,
    required this.face,
  }) : super(key: key);

  final tf.Face face;

  @override
  _DashState createState() => _DashState();
}

class _DashState extends State<_Dash> {
  _DashStateMachineController? _dashController;
  late FaceGeometry _faceGeometry = FaceGeometry.fromFace(widget.face);
  double? x;
  double? y;

  void _onRiveInit(Artboard artboard) {
    _dashController = _DashStateMachineController(artboard);
    artboard.addController(_dashController!);
  }

  @override
  void didUpdateWidget(covariant _Dash oldWidget) {
    super.didUpdateWidget(oldWidget);
    _faceGeometry = _faceGeometry.update(widget.face);
    final dashController = _dashController;
    if (dashController != null) {
      // TODO(oscar): uncomment when rotation maths are completed
      /*  final direction = widget.face.direction().unit();
      dashController.x.change(direction.x * 1000);
      dashController.y.change(direction.z * -1000);
*/
      // dashController.openMouth.change(_faceGeometry.mouth.isOpen);
      dashController.openMouth.change(_faceGeometry.mouth.isOpen);
      final direction = _faceGeometry.direction.value;
      final cos = _faceGeometry.direction.newValues;
      final verticalCos = cos[0];
      final horizontalCos = cos[1];

      // _normalize(horizontalCos * -1000, verticalCos * 1000);
      _animate(horizontalCos * -1000, verticalCos * 1000);
    }
  }

  void _normalize(double newX, double newY) {
    if (x != null && y != null) {
      final diffX = (newX - x!).abs() / newX * 100;
      final diffY = (newY - y!).abs() / newY * 100;
      if (diffX > 20 || diffY > 20) {
        const steps = 5;
        for (var index = 1; index < steps; index++) {
          _animate(
            x! + ((newX - x!) * index / steps),
            y! + ((newY - y!) * index / steps),
          );
        }
      } else {
        // x = newX;
        // y = newY;
      }
    } else {
      _animate(newX, newY);
    }
  }

  void _animate(double newX, double newY) {
    x = newX;
    y = newY;
    _dashController?.x.change(newX);
    _dashController?.y.change(newY);

    _dashController?.openMouth.change(_faceGeometry.mouth.isOpen);
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

  late final SMINumber x;
  late final SMINumber y;
  late final SMIBool openMouth;
}
