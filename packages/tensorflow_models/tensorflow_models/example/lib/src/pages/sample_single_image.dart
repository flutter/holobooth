// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_models/tensorflow_models.dart';

class SingleCapturePage extends StatefulWidget {
  const SingleCapturePage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const SingleCapturePage());
  }

  @override
  State<SingleCapturePage> createState() => _SingleCapturePageState();
}

class _SingleCapturePageState extends State<SingleCapturePage> {
  CameraController? _controller;
  late Completer<void> _cameraControllerCompleter;

  bool get _isCameraAvailable => (_controller?.value.isInitialized) ?? false;

  Future<void> _stop() async {
    if (!_isCameraAvailable) return;
    return _controller!.pausePreview();
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
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
    } catch (error) {
      _cameraControllerCompleter.completeError(error);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _onSnapPressed() async {
    final navigator = Navigator.of(context);
    final cameraImage = await _controller!.takePicture();
    await _stop();

    final previewPageRoute = PreviewPage.route(image: cameraImage);
    unawaited(navigator.push(previewPageRoute));
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
          camera = _CameraFrame(
            onSnapPressed: _onSnapPressed,
            child: _controller!.buildPreview(),
          );
        } else {
          camera = const CircularProgressIndicator();
        }

        return Scaffold(body: Center(child: camera));
      },
    );
  }
}

class _CameraFrame extends StatelessWidget {
  const _CameraFrame({
    Key? key,
    required this.onSnapPressed,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final void Function() onSnapPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ElevatedButton(
            onPressed: onSnapPressed,
            child: const Text('Take Photo'),
          ),
        ),
      ],
    );
  }
}

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key, required this.image}) : super(key: key);

  static Route<void> route({required XFile image}) {
    return MaterialPageRoute(builder: (_) => PreviewPage(image: image));
  }

  final XFile image;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  KeypointOld? keypoint;
  PoseNet? _net;
  Uint8List? _bytes;
  Pose? _poseAnalysis;

  Future<void> _analyzeImage() async {
    _net?.dispose();
    _net = await load();

    final bytes = await widget.image.readAsBytes();
    setState(() {
      _bytes = bytes;
    });

    final pose = await _net!.estimateSinglePose(widget.image.path);
    setState(() {
      _poseAnalysis = pose;
    });
    print(pose.score);

    for (final keypoint in pose.keypoints) {
      print(keypoint.part);
      print(keypoint.score);
    }
  }

  @override
  void initState() {
    super.initState();
    _analyzeImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_bytes != null)
              Image.memory(
                Uint8List.fromList(_bytes!),
                errorBuilder: (context, error, stackTrace) {
                  return Text('Error, $error, $stackTrace');
                },
              ),
            if (_poseAnalysis != null) _Results(pose: _poseAnalysis!),
          ],
        ),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({Key? key, required this.pose}) : super(key: key);

  final Pose pose;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final keypoint in pose.keypoints)
          Text('${keypoint.part} in ${keypoint.position.toStringFormatted()} '
              'with accuracy ${keypoint.score.toPercentage()}')
      ],
    );
  }
}

extension on Vector2D {
  String toStringFormatted() {
    final x = this.x.toStringAsFixed(2);
    final y = this.y.toStringAsFixed(2);
    return '($x,$y)';
  }
}

extension on num {
  String toPercentage() {
    final percentage = (this * 100).toStringAsFixed(2);
    return '$percentage %';
  }
}
