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
  late Completer<void> _cameraControllerCompleter;

  tf.PoseNet? _poseNet;
  tf.Keypoint? noseKeypoint;

  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 100),
  );

  bool get _isCameraAvailable => (_controller?.value.isInitialized) ?? false;

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
        setState(() {
          noseKeypoint = keypoint;
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
    const minimumKeypointScore = 0.9;

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
              if (noseKeypoint != null &&
                  noseKeypoint!.score > minimumKeypointScore)
                Positioned(
                  right: noseKeypoint!.position.x.toDouble() - 40,
                  top: noseKeypoint!.position.y.toDouble() - 200,
                  child: const Icon(
                    Icons.flutter_dash,
                    color: Colors.red,
                    size: 100,
                  ),
                ),
              Text(
                'Nose: ${noseKeypoint?.position.toStringFormatted()} '
                ' (${noseKeypoint?.score.percentage()})',
              ),
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

extension on num {
  String percentage() {
    return '${(this * 100).toStringAsFixed(2)}%';
  }
}
