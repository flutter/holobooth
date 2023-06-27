import 'package:camera/camera.dart';
import 'package:example/src/src.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class LandmarksDetectBlinkPage extends StatelessWidget {
  const LandmarksDetectBlinkPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LandmarksDetectBlinkPage());

  @override
  Widget build(BuildContext context) => const _LandmarksDetectBlinkView();
}

class _LandmarksDetectBlinkView extends StatefulWidget {
  const _LandmarksDetectBlinkView();

  @override
  State<_LandmarksDetectBlinkView> createState() =>
      _LandmarksDetectBlinkViewState();
}

class _LandmarksDetectBlinkViewState extends State<_LandmarksDetectBlinkView> {
  CameraController? _cameraController;

  final _imageSize = tf.Size(1280, 720);
  FaceGeometry? _faceGeometry;

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
                  final faceGeometry = _faceGeometry == null
                      ? FaceGeometry(face: face, size: _imageSize)
                      : _faceGeometry!.update(face: face, size: _imageSize);
                  _faceGeometry = faceGeometry;

                  return CustomPaint(
                    painter: _FaceLandmarkCustomPainter(
                      face: faces.first,
                      // Mirrored since the camera is mirrored.
                      isLeftEyeClose: faceGeometry.rightEye.isClosed,
                      isRightEyeClose: faceGeometry.leftEye.isClosed,
                    ),
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
    required this.isLeftEyeClose,
    required this.isRightEyeClose,
  });

  final tf.Face face;
  final bool isLeftEyeClose;
  final bool isRightEyeClose;

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
    final leftEyePaint = isLeftEyeClose ? highlightPaint : paint;
    final rightEyePaint = isRightEyeClose ? highlightPaint : paint;

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
