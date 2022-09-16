import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class LandmarksSingleImagePage extends StatelessWidget {
  const LandmarksSingleImagePage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LandmarksSingleImagePage());

  @override
  Widget build(BuildContext context) => const _LandmkarsSingleImageView();
}

class _LandmkarsSingleImageView extends StatefulWidget {
  const _LandmkarsSingleImageView({Key? key}) : super(key: key);

  @override
  State<_LandmkarsSingleImageView> createState() =>
      _LandmkarsSingleImageViewState();
}

class _LandmkarsSingleImageViewState extends State<_LandmkarsSingleImageView> {
  late final CameraController _cameraController;

  void _onCameraReady(CameraController cameraController) =>
      setState(() => _cameraController = cameraController);

  Future<void> _onSnapPressed() async {
    final navigator = Navigator.of(context);
    final picture = await _cameraController.takePicture();
    await navigator.push(_LandmarksSingleImageResults.route(picture: picture));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Camera(onCameraReady: _onCameraReady),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSnapPressed,
        child: const Icon(Icons.camera),
      ),
    );
  }
}

typedef OnCameraReadyCallback = void Function(CameraController controller);

class _Camera extends StatefulWidget {
  const _Camera({this.onCameraReady});

  final OnCameraReadyCallback? onCameraReady;

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

class _LandmarksSingleImageResults extends StatefulWidget {
  const _LandmarksSingleImageResults({required this.picture});

  static Route<void> route({required XFile picture}) => MaterialPageRoute(
        builder: (_) => _LandmarksSingleImageResults(picture: picture),
      );

  final XFile picture;

  @override
  State<_LandmarksSingleImageResults> createState() =>
      _LandmarksSingleImageResultsState();
}

class _LandmarksSingleImageResultsState
    extends State<_LandmarksSingleImageResults> {
  Uint8List? _bytes;
  tf.Faces? _faces;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future<void> _initState() async {
    final faceLandmarksDetector = await tf.TensorFlowFaceLandmarks.load();
    final bytes = await widget.picture.readAsBytes();
    final faces =
        await faceLandmarksDetector.estimateFaces(widget.picture.path);
    setState(() {
      _bytes = bytes;
      _faces = faces;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_bytes == null || _faces == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          Transform.scale(
            scaleX: -1,
            child: Image.memory(
              _bytes!,
              errorBuilder: (context, error, stackTrace) =>
                  Text('Error, $error, $stackTrace'),
            ),
          ),
          if (_faces != null)
            for (final face in _faces!)
              CustomPaint(
                painter: _FaceLandmarkCustomPainter(
                  face: face,
                  pixelRatio: MediaQuery.of(context).devicePixelRatio,
                ),
              ),
        ],
      ),
    );
  }
}

class _FaceLandmarkCustomPainter extends CustomPainter {
  const _FaceLandmarkCustomPainter({
    required this.face,
    required this.pixelRatio,
  });

  final tf.Face face;
  final double pixelRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (final keypoint in face.keypoints) {
      path.addOval(
        Rect.fromCircle(
          // TODO(alestiago): Investigate point positioning.
          center:
              Offset(keypoint.x.toDouble(), keypoint.y.toDouble()) / pixelRatio,
          radius: 1,
        ),
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FaceLandmarkCustomPainter oldDelegate) =>
      face != oldDelegate.face || pixelRatio != oldDelegate.pixelRatio;
}
