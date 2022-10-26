import 'package:camera/camera.dart';
import 'package:example/assets/assets.dart';
import 'package:example/src/src.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LandmarksMaskBlinkPage extends StatelessWidget {
  const LandmarksMaskBlinkPage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LandmarksMaskBlinkPage());

  @override
  Widget build(BuildContext context) => const _LandmarksMaskBlinkView();
}

class _LandmarksMaskBlinkView extends StatefulWidget {
  const _LandmarksMaskBlinkView({Key? key}) : super(key: key);

  @override
  State<_LandmarksMaskBlinkView> createState() =>
      _LandmarksMaskBlinkViewState();
}

class _LandmarksMaskBlinkViewState extends State<_LandmarksMaskBlinkView> {
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
                    children: [
                      _BlinkMask(face: face),
                      CustomPaint(
                        painter: _FaceLandmarkCustomPainter(face: face),
                      ),
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

class _BlinkMask extends StatefulWidget {
  const _BlinkMask({
    Key? key,
    required this.face,
  }) : super(key: key);

  final FaceGeometry face;

  @override
  _BlinkMaskState createState() => _BlinkMaskState();
}

class _BlinkMaskState extends State<_BlinkMask> {
  _BlinkStateMachineController? _leftBlinkController;
  _BlinkStateMachineController? _rightBlinkController;
  bool? wasRightEyeClosed;
  bool? wasLeftEyeClosed;

  void _onRiveInit(Artboard artboard) {
    _leftBlinkController = _BlinkStateMachineController.left(artboard);
    _rightBlinkController = _BlinkStateMachineController.right(artboard);
    artboard
      ..addController(_leftBlinkController!)
      ..addController(_rightBlinkController!);
  }

  @override
  Widget build(BuildContext context) {
    final isLeftEyeClosed = widget.face.leftEye.isClose;
    final isRightEyeClosed = widget.face.rightEye.isClose;

    if (_leftBlinkController != null) {
      if (wasLeftEyeClosed != isLeftEyeClosed && isLeftEyeClosed) {
        _rightBlinkController?.blinkTrigger.fire();
      }
      wasLeftEyeClosed = isLeftEyeClosed;
    }

    if (_rightBlinkController != null) {
      if (wasRightEyeClosed != isRightEyeClosed && isRightEyeClosed) {
        _leftBlinkController?.blinkTrigger.fire();
      }
      wasRightEyeClosed = isRightEyeClosed;
    }

    final faceSize = Size(
      widget.face.boundingBox.width.toDouble(),
      widget.face.boundingBox.height.toDouble(),
    );

    final xMin = widget.face.boundingBox.xMin.toDouble();
    final yMin = widget.face.boundingBox.yMin.toDouble();

    final maxMaskDimension =
        faceSize.width > faceSize.height ? faceSize.width : faceSize.height;

    return Positioned(
      left: xMin - maxMaskDimension / 2,
      top: yMin - (maxMaskDimension * 3 / 4),
      height: maxMaskDimension * 2,
      width: maxMaskDimension * 2,
      child: Assets.blink.rive(
        onInit: _onRiveInit,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _FaceLandmarkCustomPainter extends CustomPainter {
  _FaceLandmarkCustomPainter({
    required this.face,
  });

  final FaceGeometry face;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;
    final highlightPaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final leftEye =
        face.keypoints.where((keypoint) => keypoint.name == 'leftEye');
    final rightEye =
        face.keypoints.where((keypoint) => keypoint.name == 'rightEye');
    final leftEyePaint = face.leftEye.isClose ? highlightPaint : paint;
    final rightEyePaint = face.rightEye.isClose ? highlightPaint : paint;

    for (final keypoint in leftEye) {
      final offset = Offset(keypoint.x.toDouble(), keypoint.y.toDouble());
      canvas.drawCircle(offset, 2, leftEyePaint);
    }
    for (final keypoint in rightEye) {
      final offset = Offset(keypoint.x.toDouble(), keypoint.y.toDouble());
      canvas.drawCircle(offset, 2, rightEyePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FaceLandmarkCustomPainter oldDelegate) =>
      face.hashCode != oldDelegate.face.hashCode;
}

class _BlinkStateMachineController extends StateMachineController {
  _BlinkStateMachineController._(
    Artboard artboard, {
    required String machineName,
    required String inputName,
  }) : super(
          artboard.animations
              .whereType<StateMachine>()
              .firstWhere((stateMachine) => stateMachine.name == machineName),
        ) {
    blinkTrigger = findInput<bool>(inputName)! as SMITrigger;
  }

  factory _BlinkStateMachineController.left(Artboard artboard) =>
      _BlinkStateMachineController._(
        artboard,
        machineName: 'LeftEye',
        inputName: 'leftBlink',
      );

  factory _BlinkStateMachineController.right(Artboard artboard) =>
      _BlinkStateMachineController._(
        artboard,
        machineName: 'RightEye',
        inputName: 'rightBlink',
      );

  late SMITrigger blinkTrigger;
}
