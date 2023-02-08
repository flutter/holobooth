import 'dart:async';

import 'package:camera/camera.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class FacesDetectorBuilder extends StatefulWidget {
  const FacesDetectorBuilder({
    required this.cameraController,
    required this.builder,
    Key? key,
  }) : super(key: key);

  final CameraController cameraController;
  final Widget Function(BuildContext context, tf.Faces faces) builder;

  @override
  State<FacesDetectorBuilder> createState() => _FacesDetectorBuilderState();
}

class _FacesDetectorBuilderState extends State<FacesDetectorBuilder> {
  final _streamController = StreamController<tf.Faces>();
  late final tf.FaceLandmarksDetector _faceLandmarksDetector;
  late Size _size;

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
                return widget.builder(context, data);
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
