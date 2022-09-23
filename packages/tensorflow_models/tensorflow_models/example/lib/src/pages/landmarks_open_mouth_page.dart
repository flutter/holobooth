// TODO(alestiago): Use a plugin instead.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:camera/camera.dart';
import 'package:example/src/widgets/widgets.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class LandmarksOpenMouthPage extends StatelessWidget {
  const LandmarksOpenMouthPage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LandmarksOpenMouthPage());

  @override
  Widget build(BuildContext context) => const _LandmarksOpenMouthPage();
}

class _LandmarksOpenMouthPage extends StatefulWidget {
  const _LandmarksOpenMouthPage({Key? key}) : super(key: key);

  @override
  State<_LandmarksOpenMouthPage> createState() =>
      _LandmarksOpenMouthPageState();
}

class _LandmarksOpenMouthPageState extends State<_LandmarksOpenMouthPage> {
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
  const _FaceLandmarkCustomPainter({
    required this.face,
  });

  final tf.Face face;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = face.mouthDistance < 1 ? Colors.yellow : Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    for (final keypoint in face.keypoints) {
      if (!(keypoint.name?.contains('lips') ?? false)) continue;
      final offset = Offset(keypoint.x.toDouble(), keypoint.y.toDouble());
      canvas.drawCircle(offset, 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FaceLandmarkCustomPainter oldDelegate) =>
      face != oldDelegate.face;
}
