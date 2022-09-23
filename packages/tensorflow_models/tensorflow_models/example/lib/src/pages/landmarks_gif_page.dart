// TODO(alestiago): Use a plugin instead.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:example/src/src.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:tensorflow_models/tensorflow_models.dart' as tf;
import 'package:tensorflow_models/tensorflow_models.dart';

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
  html.VideoElement? _videoElement;
  final _imagesBytes = <Uint8List>[];

  late Face _currentFace;

  void _onCameraReady(CameraController cameraController) {
    setState(() => _cameraController = cameraController);
    WidgetsBinding.instance.addPostFrameCallback((_) => _queryVideoElement());
  }

  void _queryVideoElement() {
    final videoElement = html.querySelector('video')! as html.VideoElement;
    setState(() => _videoElement = videoElement);
  }

  Future<void> _onTakePhoto() async {
    // if (_cameraController == null) return;
    // final picture = await _cameraController!.takePicture();
    // final bytes = await picture.readAsBytes();

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
    setState(() => _imagesBytes.add(bytes!.buffer.asUint8List()));
  }

  Future<void> _downloadGif() async {
    final animation = img.Animation();
    for (final bytes in _imagesBytes) {
      animation.addFrame(img.decodeImage(bytes)!);
    }
    final gif = img.encodeGifAnimation(animation)!;

    final file = XFile.fromData(
      Uint8List.fromList(gif),
      mimeType: 'image/gif',
      name: 'animation.gif', // Use a different name?
    );

    await file.saveTo('');

    setState(_imagesBytes.clear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _onTakePhoto,
            child: const Icon(Icons.camera),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _downloadGif,
            child: const Icon(Icons.download),
          ),
        ],
      ),
      body: Row(
        children: [
          AspectRatio(
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

                          // Used for capturing the face. Here for poc.
                          _currentFace = faces.first;

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
