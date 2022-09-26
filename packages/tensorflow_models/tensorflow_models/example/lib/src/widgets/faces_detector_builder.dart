import 'dart:async';
// TODO(alestiago): Use a plugin instead.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class FacesDetectorBuilder extends StatefulWidget {
  const FacesDetectorBuilder({
    Key? key,
    required this.videoElement,
    required this.builder,
  }) : super(key: key);

  final html.VideoElement videoElement;

  final Widget Function(BuildContext context, tf.Faces faces) builder;

  @override
  State<FacesDetectorBuilder> createState() => _FacesDetectorBuilderState();
}

class _FacesDetectorBuilderState extends State<FacesDetectorBuilder> {
  final _streamController = StreamController<tf.Faces>();
  late final tf.FaceLandmarksDetector _faceLandmarksDetector;

  static const _estimationConfig = tf.EstimationConfig(
    flipHorizontal: true,
    staticImageMode: false,
  );

  @override
  void initState() {
    super.initState();
    _load().then((_) => Future.doWhile(_estimateFaces));
  }

  Future<void> _load() async =>
      _faceLandmarksDetector = await tf.TensorFlowFaceLandmarks.load();

  Future<bool> _estimateFaces() async {
    final faces = await _faceLandmarksDetector.estimateFaces(
      widget.videoElement,
      estimationConfig: _estimationConfig,
    );
    if (!_streamController.isClosed) _streamController.add(faces);
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
  }
}
