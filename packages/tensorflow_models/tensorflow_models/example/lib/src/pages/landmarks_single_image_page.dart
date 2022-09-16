import 'dart:async';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
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
  ui.Image? _image;
  tf.Faces? _faces;
  Uint8List? _bytes;

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
    final image = await decodeImageFromList(bytes);
    setState(() {
      _image = image;
      _faces = faces;
      _bytes = bytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null || _faces == null || _bytes == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    const aspectRatio = Size(1, 1.778);
    final previewSize = aspectRatio * 500;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox.fromSize(
              size: previewSize,
              child: Transform.scale(
                // TODO(alestiago): Allow passing mirrored parameter to model to avoid doing so.
                scaleX: -1,
                child: Image.memory(
                  _bytes!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Text('Error, $error, $stackTrace'),
                ),
              ),
            ),
            if (_faces != null)
              for (final face in _faces!)
                SizedBox.fromSize(
                  size: previewSize,
                  child: CustomPaint(
                    painter: _FaceLandmarkCustomPainter(
                      face: face,
                      imageSize: Size(
                        _image!.width.toDouble(),
                        _image!.height.toDouble(),
                      ),
                      previewSize: previewSize,
                    ),
                  ),
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
    required this.imageSize,
    required this.previewSize,
  });

  final tf.Face face;
  final Size imageSize;
  final Size previewSize;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (final keypoint in face.keypoints) {
      final offset = Offset(
        keypoint.x.normalize(
          fromMax: imageSize.width,
          toMax: previewSize.width,
        ),
        keypoint.y.normalize(
          fromMax: imageSize.height,
          toMax: previewSize.height,
        ),
      );
      path.addOval(
        Rect.fromCircle(
          center: offset,
          radius: 1,
        ),
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FaceLandmarkCustomPainter oldDelegate) =>
      face != oldDelegate.face;
}

extension on num {
  double normalize({
    num fromMin = 0,
    required num fromMax,
    num toMin = 0,
    required num toMax,
  }) {
    assert(fromMin < fromMax, 'fromMin must be less than fromMax');
    assert(toMin < toMax, 'toMin must be less than toMax');

    return (toMax - toMin) * ((this - fromMin) / (fromMax - fromMin)) + toMin;
  }
}
