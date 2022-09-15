// ignore_for_file: avoid_print

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class SampleRealtimePosenet extends StatefulWidget {
  const SampleRealtimePosenet({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const SampleRealtimePosenet());
  }

  @override
  State<SampleRealtimePosenet> createState() => _SampleRealtimePosenetState();
}

class _SampleRealtimePosenetState extends State<SampleRealtimePosenet>
    with SingleTickerProviderStateMixin {
  CameraController? _controller;
  tf.PoseNet? _poseNet;
  tf.Vector2D? nosePosition;
  late Completer<void> _cameraControllerCompleter;
  bool get _isCameraAvailable => (_controller?.value.isInitialized) ?? false;
  late final AnimationController animationController =
      AnimationController(vsync: this, duration: Duration(seconds: 100));

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _analyzeImage() async {
    _poseNet?.dispose();
    _poseNet = await tf.load(const tf.ModelConfig(multiplier: 1));
    animationController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _analyze();
      });
    });
    await animationController.repeat();
  }

  Future<void> _analyze() async {
    final pose = await _poseNet!.estimateSinglePoseFromVideoElement(
      config: const tf.SinglePersonInterfaceConfig(),
    );
    for (final keypoint in pose.keypoints) {
      if (keypoint.part == 'nose') {
        print(keypoint.part);
        print(keypoint.position.toStringFormatted());
        print(keypoint.score);
        setState(() {
          nosePosition = keypoint.position;
        });
      }
    }
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
          camera = Stack(
            children: [
              _controller!.buildPreview(),
              if (nosePosition != null)
                Positioned(
                  right: nosePosition!.x.toDouble() - 40,
                  top: nosePosition!.y.toDouble() - 200,
                  child: const Icon(Icons.flutter_dash,
                      color: Colors.red, size: 100),
                )
            ],
          );
        } else {
          camera = const CircularProgressIndicator();
        }

        return Scaffold(body: Center(child: camera));
      },
    );
  }
}

extension on tf.Vector2D {
  String toStringFormatted() {
    final x = this.x.toStringAsFixed(2);
    final y = this.y.toStringAsFixed(2);
    return '($x,$y)';
  }
}
