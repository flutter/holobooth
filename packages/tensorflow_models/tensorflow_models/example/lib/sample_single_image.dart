import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cross_file/cross_file.dart';
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
  late CameraController _controller;

  bool get _isCameraAvailable =>
      _controller.value.status == CameraStatus.available;

  Future<void> _play() async {
    if (!_isCameraAvailable) return;
    return _controller.play();
  }

  Future<void> _stop() async {
    if (!_isCameraAvailable) return;
    return _controller.stop();
  }

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeCameraController() async {
    _controller = CameraController();
    await _controller.initialize();
    await _play();
  }

  Future<void> _onSnapPressed() async {
    final navigator = Navigator.of(context);
    final cameraImage = await _controller.takePicture();

    final previewPageRoute = PreviewPage.route(image: cameraImage);
    //await _stop();
    unawaited(navigator.push(previewPageRoute));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Camera(
          controller: _controller,
          placeholder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          preview: (context, preview) => CameraFrame(
            onSnapPressed: _onSnapPressed,
            child: preview,
          ),
          error: (context, error) => Center(child: Text(error.description)),
        ),
      ),
    );
  }
}

class CameraFrame extends StatelessWidget {
  const CameraFrame({
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
            child: const Text('Take Photo'),
            onPressed: onSnapPressed,
          ),
        ),
      ],
    );
  }
}

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key, required this.image}) : super(key: key);

  static Route<void> route({required CameraImage image}) {
    return MaterialPageRoute(builder: (_) => PreviewPage(image: image));
  }

  final CameraImage image;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  Keypoint? keypoint;
  PoseNet? _net;
  Uint8List? _bytes;

  Future<void> _initializePosenet() async {
    _net?.dispose();
    _net = await load();
    final file = XFile(widget.image.data);

    final bytes = await file.readAsBytes();
    setState(() {
      _bytes = bytes;
    });
    final pose = await _net!.estimateSinglePose(
      ImageData(
        data: Uint8ClampedList.fromList(bytes),
        width: widget.image.width,
        height: widget.image.height,
      ),
    );
    print(pose.score);
    for (final keypoint in pose.keypoints) {
      print(keypoint.part);
      print(keypoint.score);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializePosenet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: Stack(
        children: [
          if (_bytes != null)
            Positioned.fill(
              child: Image.memory(
                Uint8List.fromList(_bytes!),
                errorBuilder: (context, error, stackTrace) {
                  return Text('Error, $error, $stackTrace');
                },
              ),
            ),
        ],
      ),
    );
  }
}
