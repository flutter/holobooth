import 'package:camera/camera.dart';
import 'package:example/src/src.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class LandmarksVideoStreamPage extends StatelessWidget {
  const LandmarksVideoStreamPage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LandmarksVideoStreamPage());

  @override
  Widget build(BuildContext context) => const _LandmarksVideoStreamView();
}

class _LandmarksVideoStreamView extends StatefulWidget {
  const _LandmarksVideoStreamView({Key? key}) : super(key: key);

  @override
  State<_LandmarksVideoStreamView> createState() =>
      _LandmarksVideoStreamViewState();
}

class _LandmarksVideoStreamViewState extends State<_LandmarksVideoStreamView> {
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
          fit: StackFit.expand,
          children: [
            Center(child: CameraView(onCameraReady: _onCameraReady)),
            if (_cameraController != null)
              FacesDetectorBuilder(
                cameraController: _cameraController!,
                builder: (context, faces) {
                  if (faces.isEmpty) return const SizedBox.shrink();
                  return CustomPaint(
                    painter: _FaceLandmarkCustomPainter(
                      face: faces.first,
                    ),
                  );
                },
              )
          ],
        ),
      ),
    );
  }
}

class _FaceLandmarkCustomPainter extends CustomPainter {
  const _FaceLandmarkCustomPainter({
    required this.face,
  });

  final tf.Face face;

  @override
  void paint(Canvas canvas, Size size) {
    final paintKeypoints = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (final keypoint in face.keypoints) {
      final offset = Offset(keypoint.x.toDouble(), keypoint.y.toDouble());
      path.addOval(
        Rect.fromCircle(
          center: offset,
          radius: 1,
        ),
      );
    }
    canvas.drawPath(path, paintKeypoints);

    final boundingBox = face.boundingBox;
    final paintBox = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawRect(
      Rect.fromPoints(
        Offset(boundingBox.xMin.toDouble(), boundingBox.yMin.toDouble()),
        Offset(boundingBox.xMax.toDouble(), boundingBox.yMax.toDouble()),
      ),
      paintBox,
    );
  }

  @override
  bool shouldRepaint(covariant _FaceLandmarkCustomPainter oldDelegate) =>
      face != oldDelegate.face;
}
