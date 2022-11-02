import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:example/src/src.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gif_compositor/gif_compositor.dart';

import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class LandmarksGifPage extends StatelessWidget {
  const LandmarksGifPage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LandmarksGifPage());

  @override
  Widget build(BuildContext context) => const _LandmarksGifView();
}

class _LandmarksGifView extends StatefulWidget {
  const _LandmarksGifView();

  @override
  State<_LandmarksGifView> createState() => _LandmarksGifViewState();
}

class _LandmarksGifViewState extends State<_LandmarksGifView> {
  CameraController? _cameraController;
  final _imagesBytes = <Uint8List>[];
  bool _gifInProgress = false;

  late tf.Face _currentFace;

  void _onCameraReady(CameraController cameraController) {
    setState(() => _cameraController = cameraController);
  }

  Future<void> _onTakePhoto() async {
    print('keypoints: ${_currentFace.keypoints.prettyPrint()}');
    print('boundingBox: ${_currentFace.boundingBox.prettyPrint()}');
    // Save the canvas that the face is drawn to as a png.
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder)
      ..drawColor(Colors.white, BlendMode.color);

    _FaceLandmarkCustomPainter(
      face: _currentFace,
    ).paint(canvas, context.size!);

    final image = await pictureRecorder
        .endRecording()
        .toImage(context.size!.width.floor(), context.size!.height.floor());
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    final bytesList = bytes!.buffer.asUint8List();
    setState(() => _imagesBytes.add(bytesList));
  }

  Future<void> _downloadGif() async {
    setState(() => _gifInProgress = true);

    try {
      final gif = await GifCompositor.composite(
        images: _imagesBytes,
        fileName: 'output.gif',
      );
      await gif.saveTo('');

      setState(() {
        _imagesBytes.clear();
        _gifInProgress = false;
      });
    } catch (error) {
      final errorMessage = error.toString();
      debugPrint(errorMessage);

      final snackBar = SnackBar(content: Text(errorMessage));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() => _gifInProgress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: _onTakePhoto,
            child: const Icon(Icons.camera),
          ),
          const SizedBox(width: 16),
          if (_gifInProgress)
            FloatingActionButton(
              heroTag: null,
              onPressed: () {},
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          else
            FloatingActionButton(
              heroTag: null,
              onPressed: _downloadGif,
              child: const Icon(Icons.download),
            ),
        ],
      ),
      body: Row(
        children: [
          Flexible(
            child: AspectRatio(
              aspectRatio: _cameraController?.value.aspectRatio ?? 1,
              child: Stack(
                children: [
                  CameraView(onCameraReady: _onCameraReady),
                  if (_cameraController != null)
                    FacesDetectorBuilder(
                      cameraController: _cameraController!,
                      builder: (context, faces) {
                        if (faces.isEmpty) return const SizedBox.shrink();
                        // Used for capturing the face. Here for POC. (@marwfair)
                        _currentFace = faces.first;

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
          ),
          _ImagePreview(
            images:
                _imagesBytes.map((bytes) => Image.memory(bytes).image).toList(),
          ),
        ],
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
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FaceLandmarkCustomPainter oldDelegate) =>
      face != oldDelegate.face;
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.images});

  final List<ImageProvider> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return Image(image: image);
        },
      ),
    );
  }
}

extension on UnmodifiableListView<tf.Keypoint> {
  String prettyPrint() {
    final sb = StringBuffer();
    sb.writeln('[');
    for (final keypoint in this) {
      sb.writeln(keypoint.prettyPrint());
    }
    sb.writeln(']');
    return sb.toString();
  }
}

extension on tf.Keypoint {
  String prettyPrint() {
    return "Keypoint($x, $y, $z, $score, ${name == null ? null : '${this.name}'},),";
  }
}

extension on tf.BoundingBox {
  String prettyPrint() {
    return 'BoundingBox($xMin, $yMin, $xMax, $yMax, $width, $height,),';
  }
}
