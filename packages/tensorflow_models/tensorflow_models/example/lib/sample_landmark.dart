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
  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
  FaceLandmarksDetector? faceLandmarksDetector;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Landmark'),
      ),
      body: _CameraPreview(),
    );
  }
}

class _CameraPreview extends StatefulWidget {
  const _CameraPreview({Key? key}) : super(key: key);

  @override
  State<_CameraPreview> createState() => _CameraPreviewState();
}

class _CameraPreviewState extends State<_CameraPreview> {
  late CameraController _cameraController;
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
