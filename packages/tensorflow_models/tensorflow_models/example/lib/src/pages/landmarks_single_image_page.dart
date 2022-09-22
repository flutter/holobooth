import 'dart:async';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:example/src/src.dart';
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
  CameraController? _cameraController;

  bool get _isCameraAvailable =>
      (_cameraController?.value.isInitialized) ?? false;

  void _onCameraReady(CameraController cameraController) =>
      setState(() => _cameraController = cameraController);

  Future<void> _stop() async {
    if (!_isCameraAvailable) return;
    return _cameraController!.pausePreview();
  }

  Future<void> _onSnapPressed() async {
    if (!_isCameraAvailable) return;

    final navigator = Navigator.of(context);
    final picture = await _cameraController!.takePicture();
    await _stop();
    await navigator.push(_LandmarksSingleImageResults.route(picture: picture));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CameraView(onCameraReady: _onCameraReady)),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSnapPressed,
        child: const Icon(Icons.camera),
      ),
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
  bool isLoading = true;
  late final ui.Image _image;
  late final tf.Faces _faces;
  late final Uint8List _bytes;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future<void> _initState() async {
    final faceLandmarksDetector = await tf.TensorFlowFaceLandmarks.load();
    _bytes = await widget.picture.readAsBytes();
    _faces = await faceLandmarksDetector.estimateFaces(widget.picture.path);
    _image = await decodeImageFromList(_bytes);
    faceLandmarksDetector.dispose();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final previewSize = Size(1, _image.height / _image.width) * 500;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox.fromSize(
              size: previewSize,
              child: Image.memory(
                _bytes,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Text('Error, $error, $stackTrace'),
              ),
            ),
            for (final face in _faces)
              SizedBox.fromSize(
                size: previewSize,
                child: CustomPaint(
                  painter: _FaceLandmarkCustomPainter(
                    face: face,
                    imageSize: Size(
                      _image.width.toDouble(),
                      _image.height.toDouble(),
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
