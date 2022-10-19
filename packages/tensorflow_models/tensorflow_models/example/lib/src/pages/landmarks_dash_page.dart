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
              opacity: isCameraVisible ? 1 : 0,
              child: CameraView(onCameraReady: _onCameraReady),
            ),
            if (_cameraController != null)
              FacesDetectorBuilder(
                cameraController: _cameraController!,
                builder: (context, faces) {
                  if (faces.isEmpty) return const SizedBox.shrink();
                  final face = faces.first;

                  return Center(
                    child: _Dash(face: face),
                  );
                },
              ),
            if (_cameraController != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isCameraVisible = !isCameraVisible;
                    });
                  },
                  child: Text(
                      isCameraVisible ? 'Hide the camera' : 'Show the camera'),
                ),
              )
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

  void _onRiveInit(Artboard artboard) {
    _dashController = _DashStateMachineController(artboard);
    artboard.addController(_dashController!);
  }

  @override
  void didUpdateWidget(covariant _Dash oldWidget) {
    super.didUpdateWidget(oldWidget);
    final dashController = _dashController;
    if (dashController != null) {
      final direction = widget.face.direction().unit();
      dashController.x.change(direction.x * 1000);
      dashController.y.change(direction.z * -1000);

      dashController.openMouth.change(widget.face.isMouthOpen);
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
      width: 100,
      height: 100,
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
