import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_models/tensorflow_models.dart';

class SampleLandmark extends StatefulWidget {
  const SampleLandmark({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const SampleLandmark());
  }

  @override
  State<SampleLandmark> createState() => _SampleLandmarkState();
}

class _SampleLandmarkState extends State<SampleLandmark>
    with SingleTickerProviderStateMixin {
  CameraController? _controller;
  late Completer<void> _cameraControllerCompleter;
  bool get _isCameraAvailable => (_controller?.value.isInitialized) ?? false;
  late final AnimationController animationController =
      AnimationController(vsync: this, duration: Duration(seconds: 1));
  FaceLandmarksDetector? faceLandmarksDetector;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _analyzeImage() async {
    faceLandmarksDetector?.dispose();
    faceLandmarksDetector = await loadFaceLandmark();

    animationController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (faceLandmarksDetector == null) return;
        final faces = await faceLandmarksDetector!.estimateFaces();
        for (final face in faces) {
          for (final keypoint in face.keypoints) {
            print(keypoint);
          }
        }
      });
    });
    await animationController.repeat();
  }

  Future<void> _initializeCamera() async {
    if (_isCameraAvailable) return;

    _cameraControllerCompleter = Completer<void>();
    try {
      final cameras = await availableCameras();
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.max,
        enableAudio: false,
      );
      await _controller!.initialize();
      _cameraControllerCompleter.complete();
      unawaited(_analyzeImage());
    } catch (error) {
      _cameraControllerCompleter.completeError(error);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Landmark'),
        ),
        body: FutureBuilder<void>(
          future: _cameraControllerCompleter.future,
          builder: (context, snapshot) {
            late final Widget camera;
            if (snapshot.hasError) {
              final error = snapshot.error;
              if (error is CameraException) {
                camera = Text('${error.code} : ${error.description}');
              }
            } else if (snapshot.connectionState == ConnectionState.done) {
              camera = Stack(
                children: [
                  _controller!.buildPreview(),
                ],
              );
            } else {
              camera = const CircularProgressIndicator();
            }

            return Scaffold(body: Center(child: camera));
          },
        ));
  }
}
