// TODO(alestiago): Use a plugin instead.
// ignore: avoid_web_libraries_in_flutter
import 'dart:collection';
import 'dart:html' as html;
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:example/src/src.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

final leftEyeRatioQueue = ListQueue<double>(30);
final rightEyeRatioQueue = ListQueue<double>(30);

extension on tf.Keypoint {
  double euclaideanDistance(tf.Keypoint other) =>
      math.sqrt(math.pow(other.x - x, 2) + math.pow(other.y - y, 2));
}

extension on tf.Face {
  double leftEyeRatio() {
    final right = keypoints[362];
    final left = keypoints[263];
    final top = keypoints[386];
    final bottom = keypoints[374];

    final lvDistance = top.euclaideanDistance(bottom);
    final lhDistance = right.euclaideanDistance(left);

    return lhDistance / lvDistance;
  }

  double rightEyeRatio() {
    final right = keypoints[33];
    final left = keypoints[133];
    final top = keypoints[159];
    final bottom = keypoints[145];

    final rhDistance = right.euclaideanDistance(left);
    final rvDistance = top.euclaideanDistance(bottom);

    return rhDistance / rvDistance;
  }
}

class LandmarksDetectBlinkPage extends StatelessWidget {
  const LandmarksDetectBlinkPage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LandmarksDetectBlinkPage());

  @override
  Widget build(BuildContext context) => const _LandmarksDetectBlinkView();
}

class _LandmarksDetectBlinkView extends StatefulWidget {
  const _LandmarksDetectBlinkView({Key? key}) : super(key: key);

  @override
  State<_LandmarksDetectBlinkView> createState() =>
      _LandmarksDetectBlinkViewState();
}

class _LandmarksDetectBlinkViewState extends State<_LandmarksDetectBlinkView> {
  CameraController? _cameraController;
  html.VideoElement? _videoElement;

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
                      if (faces.isEmpty) return const SizedBox.shrink();

                      return SizedBox.fromSize(
                        size: size,
                        child: CustomPaint(
                          painter: _FaceLandmarkCustomPainter(
                            face: faces.first,
                          ),
                        ),
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

class _FaceLandmarkCustomPainter extends CustomPainter {
  _FaceLandmarkCustomPainter({
    required this.face,
  });

  final tf.Face face;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    final leftEyeRatio = face.leftEyeRatio();
    final rightEyeRatio = face.rightEyeRatio();

    final blink = (rightEyeRatio + leftEyeRatio) / 2;
    leftEyeRatioQueue.add(leftEyeRatio);
    rightEyeRatioQueue.add(rightEyeRatio);

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

    final leftEyeBlink = blink > 4 && leftEyeRatio > leftEyeRatioQueue.average;
    final rightEyeBlink =
        blink > 4 && rightEyeRatio > rightEyeRatioQueue.average;

    final leftEyePaint = leftEyeBlink ? highlightPaint : paint;
    final rightEyePaint = rightEyeBlink ? highlightPaint : paint;

    for (final keypoint in leftEye) {
      final offset = Offset(keypoint.x.toDouble(), keypoint.y.toDouble());
      canvas.drawCircle(offset, 2, leftEyePaint);
    }
    for (final keypoint in rightEye) {
      final offset = Offset(keypoint.x.toDouble(), keypoint.y.toDouble());
      canvas.drawCircle(offset, 2, rightEyePaint);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FaceLandmarkCustomPainter oldDelegate) =>
      face != oldDelegate.face;
}
