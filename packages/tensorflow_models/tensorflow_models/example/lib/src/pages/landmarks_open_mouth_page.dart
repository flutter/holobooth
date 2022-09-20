import 'dart:async';
import 'dart:math' as math;

// TODO(alestiago): Use a plugin instead.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:camera/camera.dart';
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
            _Camera(onCameraReady: _onCameraReady),
            if (_videoElement != null)
              LayoutBuilder(
                builder: (context, constraints) {
                  final size = constraints.biggest;
                  _videoElement!
                    ..width = size.width.floor()
                    ..height = size.height.floor();

                  return _FacesDetectorBuilder(
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

class _Camera extends StatefulWidget {
  const _Camera({this.onCameraReady});

  final void Function(CameraController controller)? onCameraReady;

  @override
  State<_Camera> createState() => _CameraState();
}

class _CameraState extends State<_Camera> {
  late final CameraController _cameraController;
  final Completer<void> _cameraControllerCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (_cameraControllerCompleter.isCompleted) return;

    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.max,
        enableAudio: false,
      );
      await _cameraController.initialize();
      widget.onCameraReady?.call(_cameraController);
      _cameraControllerCompleter.complete();
    } catch (error) {
      _cameraControllerCompleter.completeError(error);
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _cameraControllerCompleter.future,
      builder: (context, snapshot) {
        late final Widget camera;
        if (snapshot.hasError) {
          final error = snapshot.error;
          if (error is CameraException) {
            camera = Text('${error.code} : ${error.description}');
          } else {
            camera = Text('Unknown error: $error');
          }
        } else if (snapshot.connectionState == ConnectionState.done) {
          camera = _cameraController.buildPreview();
        } else {
          camera = const CircularProgressIndicator();
        }

        return Scaffold(body: Center(child: camera));
      },
    );
  }
}

class _FacesDetectorBuilder extends StatefulWidget {
  const _FacesDetectorBuilder({
    required this.videoElement,
    required this.builder,
  });

  final html.VideoElement videoElement;

  final Widget Function(BuildContext context, tf.Faces faces) builder;

  @override
  State<_FacesDetectorBuilder> createState() => _FacesDetectorBuilderState();
}

class _FacesDetectorBuilderState extends State<_FacesDetectorBuilder> {
  late final tf.FaceLandmarksDetector _faceLandmarksDetector;
  tf.Faces? _faces;

  static const _estimationConfig = tf.EstimationConfig(
    flipHorizontal: true,
    staticImageMode: false,
  );

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _faceLandmarksDetector = await tf.TensorFlowFaceLandmarks.load();
    await _detect();
  }

  Future<void> _detect() async {
    final faces = await _faceLandmarksDetector.estimateFaces(
      widget.videoElement,
      estimationConfig: _estimationConfig,
    );
    setState(() => _faces = faces);

    WidgetsBinding.instance.addPostFrameCallback((_) => _detect());
  }

  @override
  void dispose() {
    _faceLandmarksDetector.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_faces == null) return const SizedBox.shrink();
    return widget.builder(context, _faces!);
  }
}

class _FaceLandmarkCustomPainter extends CustomPainter {
  const _FaceLandmarkCustomPainter({
    required this.face,
  });

  final tf.Face face;

  @override
  void paint(Canvas canvas, Size size) {
    final topLipPoint = face.keypoints[13];
    final bottomLipPoint = face.keypoints[14];
    final dx = topLipPoint.x - bottomLipPoint.x;
    final dy = topLipPoint.y - bottomLipPoint.y;
    final distance = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
    final isMouthOpened = distance > 1;
    final paint = Paint()
      ..color = isMouthOpened ? Colors.yellow : Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final lips = face.keypoints.where(
      (keypoint) => keypoint.name?.contains('lips') ?? false,
    );
    for (final keypoint in lips) {
      final offset = Offset(keypoint.x.toDouble(), keypoint.y.toDouble());
      canvas.drawCircle(offset, 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FaceLandmarkCustomPainter oldDelegate) =>
      face != oldDelegate.face;
}
