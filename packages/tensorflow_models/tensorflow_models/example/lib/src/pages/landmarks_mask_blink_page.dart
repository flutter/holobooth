// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:math' as math;
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:example/src/src.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;
import 'package:tensorflow_models/tensorflow_models.dart';

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
  html.VideoElement? _videoElement;
  Point? facePosition;

  void _onCameraReady(CameraController cameraController) {
    setState(() => _cameraController = cameraController);
    WidgetsBinding.instance.addPostFrameCallback((_) => _queryVideoElement());
  }

  void _queryVideoElement() {
    final videoElement = html.querySelector('video')! as html.VideoElement;
    setState(() => _videoElement = videoElement);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AspectRatio(
        aspectRatio: _cameraController?.value.aspectRatio ?? 1,
        child: Stack(
          children: [
            CameraView(onCameraReady: _onCameraReady),
            if (_videoElement != null)
              LayoutBuilder(
                builder: (context, constraints) {
                  final size = constraints.biggest;

                  _videoElement!
                    ..width = size.width.floor()
                    ..height = size.height.floor();

                  return FacesDetectorBuilder(
                    videoElement: _videoElement!,
                    builder: (context, faces) {
                      if (faces.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Stack(
                        children: [
                          _BlinkMask(face: faces.first),
                          SizedBox.fromSize(
                            size: size,
                            child: CustomPaint(
                              painter: _FaceLandmarkCustomPainter(
                                face: faces.first,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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

  final tf.Face face;

  @override
  __BlinkMaskState createState() => __BlinkMaskState();
}

class __BlinkMaskState extends State<_BlinkMask> {
  _BlinkController? _leftBlinkController;
  _BlinkController? _rightBlinkController;
  // Values to block mask blinking when eyes are closed
  bool? wasRightEyeClosed;
  bool? wasLeftEyeClosed;

  void _onRiveInit(Artboard artboard) {
    _leftBlinkController = _BlinkController.left(artboard);
    _rightBlinkController = _BlinkController.right(artboard);
    artboard
      ..addController(_leftBlinkController!)
      ..addController(_rightBlinkController!);
  }

  @override
  Widget build(BuildContext context) {
    final isLeftEyeClosed = widget.face.isLeftEyeClosed();
    final isRightEyeClosed = widget.face.isRightEyeClosed();

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

    final faceOvalSize = widget.face.faceOvalSize();
    final faceOvalCenter = widget.face.faceOvalCenter();

    final maskSize = faceOvalSize.width > faceOvalSize.height
        ? faceOvalSize.width
        : faceOvalSize.height;

    return Positioned(
      left: faceOvalCenter.x - maskSize,
      top: faceOvalCenter.y - maskSize / 2,
      height: maskSize * 2,
      width: maskSize * 2,
      child: RiveAnimation.asset(
        'blink.riv',
        fit: BoxFit.cover,
        onInit: _onRiveInit,
      ),
    );
  }
}

class _FaceLandmarkCustomPainter extends CustomPainter {
  _FaceLandmarkCustomPainter({
    required this.face,
  });

  final tf.Face face;

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
    final leftEyePaint = face.isLeftEyeClosed() ? highlightPaint : paint;
    final rightEyePaint = face.isRightEyeClosed() ? highlightPaint : paint;

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
      face != oldDelegate.face;
}

class _BlinkController extends StateMachineController {
  _BlinkController._(
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

  factory _BlinkController.left(Artboard artboard) => _BlinkController._(
        artboard,
        machineName: 'LeftEye',
        inputName: 'leftBlink',
      );

  factory _BlinkController.right(Artboard artboard) => _BlinkController._(
        artboard,
        machineName: 'RightEye',
        inputName: 'rightBlink',
      );

  late SMITrigger blinkTrigger;
}

extension on tf.Face {
  bool isLeftEyeClosed() {
    final top = keypoints[386];
    final bottom = keypoints[374];
    final dx = top.x - bottom.x;
    final dy = top.y - bottom.y;
    final distance = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
    return distance < 10;
  }

  bool isRightEyeClosed() {
    final top = keypoints[159];
    final bottom = keypoints[145];
    final dx = top.x - bottom.x;
    final dy = top.y - bottom.y;
    final distance = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
    return distance < 10;
  }

  Point faceOvalCenter() {
    final facePoints = _getFacePoints();
    final xCenter = (facePoints[1].x + facePoints[0].x) / 2;
    final yCenter = (facePoints[2].y + facePoints[3].y) / 2;

    return Point(xCenter, yCenter);
  }

  Size faceOvalSize() {
    final facePoints = _getFacePoints();
    final xSize = (facePoints[1].x - facePoints[0].x).toDouble();
    final ySize = (facePoints[2].y - facePoints[3].y).toDouble();

    return Size(xSize, ySize);
  }

  List<Keypoint> _getFacePoints() {
    final faceOvals = keypoints.where((k) => k.name == 'faceOval');
    final left = faceOvals.reduce(
      (item1, item2) => item1.x < item2.x ? item1 : item2,
    );
    final right = faceOvals.reduce(
      (item1, item2) => item1.x > item2.x ? item1 : item2,
    );
    final top = faceOvals.reduce(
      (item1, item2) => item1.y < item2.y ? item1 : item2,
    );
    final bottom = faceOvals.reduce(
      (item1, item2) => item1.y < item2.y ? item1 : item2,
    );
    return [left, right, top, bottom];
  }
}
