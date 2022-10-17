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
            CameraView(onCameraReady: _onCameraReady),
            if (_cameraController != null)
              FacesDetectorBuilder(
                cameraController: _cameraController!,
                builder: (context, faces) {
                  if (faces.isEmpty) return const SizedBox.shrink();
                  final face = faces.first;

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      _Dash(face: face),
                    ],
                  );
                },
              ),
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
      final xRotation = (direction.x * 1000) + 70;
      print('xRotation: $xRotation');
      dashController.xRotation.change(xRotation);
    }
  }

  @override
  void dispose() {
    _dashController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boundingBox = widget.face.boundingBox;
    final xMin = widget.face.boundingBox.xMin.toDouble();
    final yMin = widget.face.boundingBox.yMin.toDouble();

    return Positioned(
      left: xMin,
      top: yMin,
      width: boundingBox.width.toDouble(),
      height: boundingBox.height.toDouble(),
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
    xRotation =
        inputs.firstWhere((input) => input.name == 'xRotation') as SMINumber;
  }

  late final SMINumber xRotation;
}
