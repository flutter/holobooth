// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class SingleCapturePage extends StatefulWidget {
  const SingleCapturePage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const SingleCapturePage());
  }

  @override
  State<SingleCapturePage> createState() => _SingleCapturePageState();
}

class _SingleCapturePageState extends State<SingleCapturePage> {
  CameraController? _cameraController;
  late Completer<void> _cameraControllerCompleter;

  bool get _isCameraAvailable =>
      (_cameraController?.value.isInitialized) ?? false;

  Future<void> _stop() async {
    if (!_isCameraAvailable) return;
    return _cameraController!.pausePreview();
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
      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.max,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      _cameraControllerCompleter.complete();
    } catch (error) {
      _cameraControllerCompleter.completeError(error);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _onSnapPressed() async {
    final navigator = Navigator.of(context);
    final cameraImage = await _cameraController!.takePicture();
    await _stop();

    final previewPageRoute = _PreviewPage.route(image: cameraImage);
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
            child: _cameraController!.buildPreview(),
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

class _PreviewPage extends StatefulWidget {
  const _PreviewPage({Key? key, required this.image}) : super(key: key);

  static Route<void> route({required XFile image}) {
    return MaterialPageRoute(builder: (_) => _PreviewPage(image: image));
  }

  final XFile image;

  @override
  State<_PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<_PreviewPage> {
  tf.Keypoint? keypoint;
  tf.PoseNet? _poseNet;
  Uint8List? _bytes;
  tf.Pose? _poseAnalysis;

  Future<void> _analyzeImage() async {
    _poseNet?.dispose();
    _poseNet = await tf.load();
    final bytes = await widget.image.readAsBytes();
    final pose = await _poseNet!.estimateSinglePose(widget.image.path);
    setState(() {
      _poseAnalysis = pose;
      _bytes = bytes;
    });
  }

  @override
  void initState() {
    super.initState();
    _analyzeImage();
  }

  @override
  void dispose() {
    _poseNet?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            if (_bytes != null)
              Image.memory(
                Uint8List.fromList(_bytes!),
                errorBuilder: (context, error, stackTrace) {
                  return Text('Error, $error, $stackTrace');
                },
              ),
            if (_poseAnalysis != null)
              for (final keypoint in _poseAnalysis!.keypoints)
                if (keypoint.score > 0.5) ...[
                  Positioned(
                    left: keypoint.position.x.toDouble(),
                    top: keypoint.position.y.toDouble(),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.lerp(
                          Colors.red,
                          Colors.green,
                          keypoint.score.toDouble(),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: keypoint.position.x.toDouble(),
                    top: keypoint.position.y.toDouble(),
                    child: Text(
                      keypoint.part,
                      style: const TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                  ),
                ]
          ],
        ),
      ),
    );
  }
}
