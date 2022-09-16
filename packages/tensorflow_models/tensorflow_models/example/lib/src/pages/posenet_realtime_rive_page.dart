import 'dart:async';
// TODO(alestiago): Remove the need of this import by using plugins.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class PoseNetRealtimeRivePage extends StatefulWidget {
  const PoseNetRealtimeRivePage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const PoseNetRealtimeRivePage());

  @override
  State<PoseNetRealtimeRivePage> createState() =>
      _PoseNetRealtimeRivePageState();
}

class _PoseNetRealtimeRivePageState extends State<PoseNetRealtimeRivePage> {
  html.VideoElement? _videoElement;

  void _onCameraReady(CameraController cameraController) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final videoElement =
          html.document.querySelector('video')! as html.VideoElement;
      final windowSize = MediaQuery.of(context).size;
      videoElement
        ..width = windowSize.width.toInt()
        ..height = windowSize.height.toInt();
      setState(() => _videoElement = videoElement);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Transform.scale(
            scaleX: -1,
            child: _Camera(
              onCameraReady: _onCameraReady,
            ),
          ),
          if (_videoElement != null)
            _PoseNetOverlay(videoElement: _videoElement!),
        ],
      ),
    );
  }
}

class _Camera extends StatefulWidget {
  const _Camera({
    this.onCameraReady,
  });

  final void Function(CameraController controller)? onCameraReady;

  @override
  State<_Camera> createState() => _CameraState();
}

class _CameraState extends State<_Camera> {
  late CameraController _cameraController;
  final Completer<void> _cameraControllerCompleter = Completer();

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
      widget.onCameraReady?.call(_cameraController);
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

        return camera;
      },
    );
  }
}

class _PoseNetOverlay extends StatefulWidget {
  const _PoseNetOverlay({required this.videoElement});

  final html.VideoElement videoElement;

  @override
  State<_PoseNetOverlay> createState() => _PoseNetOverlayState();
}

class _PoseNetOverlayState extends State<_PoseNetOverlay> {
  tf.Pose? _pose;
  tf.PoseNet? _poseNet;
  _BearRiveAnimationController? _bearRiveAnimationController;

  static const _maskSize = Size(600, 600);

  @override
  void initState() {
    super.initState();
    _estimateSinglePose();
  }

  @override
  void dispose() {
    _poseNet?.dispose();
    super.dispose();
  }

  Future<void> _estimateSinglePose() async {
    _poseNet = await tf.load();
    final pose = await _poseNet!.estimateSinglePose(widget.videoElement);
    setState(() => _pose = pose);
  }

  void _shouldAnimate() {
    final controller = _bearRiveAnimationController;
    final pose = _pose;
    if (controller == null) return;
    if (pose == null) return;

    final leftWrist = pose.keypoints.firstWhere((k) => k.part == 'leftWrist');
    final rightWrist = pose.keypoints.firstWhere((k) => k.part == 'rightWrist');
    final hasHandsUp = leftWrist.score > 0.9 && rightWrist.score > 0.9;
    controller.isHandsUp.change(hasHandsUp);
  }

  void _onBearRiveAnimationControllerReady(
    _BearRiveAnimationController controller,
  ) =>
      setState(() => _bearRiveAnimationController = controller);

  @override
  Widget build(BuildContext context) {
    final pose = _pose;
    if (pose == null) return const SizedBox();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _estimateSinglePose();
      _shouldAnimate();
    });

    final noseKeypoint = pose.keypoints.firstWhere((k) => k.part == 'nose');
    return Positioned(
      // TODO(alestiago): Try and fix the camera preview effect so that coordinates are precise, or
      // tweak coordinates according to the preview.
      left: (noseKeypoint.position.x.toDouble() - 30) - (_maskSize.width / 2),
      top: noseKeypoint.position.y.toDouble() - (_maskSize.height / 2),
      child: SizedBox.fromSize(
        size: _maskSize,
        child: _Bear(
          onControllerReady: _onBearRiveAnimationControllerReady,
        ),
      ),
    );
  }
}

class _Bear extends StatefulWidget {
  const _Bear({
    this.onControllerReady,
  });

  final void Function(_BearRiveAnimationController controller)?
      onControllerReady;

  @override
  _BearState createState() => _BearState();
}

class _BearState extends State<_Bear> {
  _BearRiveAnimationController? _controller;

  void _onRiveInit(Artboard artboard) {
    _controller = _BearRiveAnimationController(artboard);
    artboard.addController(_controller!);
    widget.onControllerReady?.call(_controller!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'bear.rive',
      fit: BoxFit.cover,
      onInit: _onRiveInit,
    );
  }
}

class _BearRiveAnimationController extends StateMachineController {
  _BearRiveAnimationController(Artboard artboard)
      : super(
          artboard.animations.whereType<StateMachine>().firstWhere(
                (stateMachine) => stateMachine.name == 'Login Machine',
              ),
        ) {
    isHandsUp = findInput<bool>('isHandsUp')! as SMIBool;
  }

  late SMIBool isHandsUp;
}
