import 'dart:async';

import 'package:camera/camera.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class FacesDetectorBuilder extends StatefulWidget {
  const FacesDetectorBuilder({
    Key? key,
    required this.cameraController,
    required this.builder,
    this.showFaceGeometryOverlay = kDebugMode,
  }) : super(key: key);

  final CameraController cameraController;
  final Widget Function(BuildContext context, tf.Faces faces) builder;
  final bool showFaceGeometryOverlay;

  @override
  State<FacesDetectorBuilder> createState() => _FacesDetectorBuilderState();
}

class _FacesDetectorBuilderState extends State<FacesDetectorBuilder> {
  final _streamController = StreamController<tf.Faces>();
  late final tf.FaceLandmarksDetector _faceLandmarksDetector;
  late Size _size;
  FaceGeometry? _faceGeometry;

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
    await widget.cameraController.startImageStream((image) {
      final imageData = tf.ImageData(
        bytes: image.planes.first.bytes,
        size: tf.Size(image.width, image.height),
      );
      _estimateFaces(imageData);
    });
  }

  Future<bool> _estimateFaces(tf.ImageData imageData) async {
    final faces = (await _faceLandmarksDetector.estimateFaces(
      imageData,
      estimationConfig: _estimationConfig,
    ))
        .normalize(
      fromMax: imageData.size,
      toMax: tf.Size(_size.width.toInt(), _size.height.toInt()),
    );
    if (!_streamController.isClosed) {
      if (faces.isNotEmpty && widget.showFaceGeometryOverlay) {
        _faceGeometry = _faceGeometry == null
            ? FaceGeometry.fromFace(faces.first)
            : _faceGeometry!.update(faces.first);
      }

      _streamController.add(faces);
    }
    return !_streamController.isClosed;
  }

  @override
  void dispose() {
    _faceLandmarksDetector.dispose();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.cameraController.value.aspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _size = constraints.biggest;
          return StreamBuilder<tf.Faces>(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              final data = snapshot.data;
              if (data != null) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    widget.builder(context, data),
                    if (widget.showFaceGeometryOverlay && _faceGeometry != null)
                      _FaceGeometryOverlay(faceGeometry: _faceGeometry!),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}

class _FaceGeometryOverlay extends StatelessWidget {
  const _FaceGeometryOverlay({
    Key? key,
    required this.faceGeometry,
  }) : super(key: key);

  final FaceGeometry faceGeometry;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Right Eye: ${faceGeometry.rightEye.isClosed ? 'Closed' : 'Open'}\n'
      'Left Eye: ${faceGeometry.leftEye.isClosed ? 'Closed' : 'Open'}\n'
      'Mouth: ${faceGeometry.mouth.isOpen ? 'Open' : 'Closed'}\n'
      'Direction X: ${faceGeometry.direction.value.x}\n'
      'Direction Y: ${faceGeometry.direction.value.y}\n'
      'Direction Z: ${faceGeometry.direction.value.z}\n',
    );
  }
}
