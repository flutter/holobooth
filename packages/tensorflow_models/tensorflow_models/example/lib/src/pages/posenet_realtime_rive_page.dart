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

  @override
  void initState() {
    super.initState();
    _estimateSinglePose();
  }

  Future<void> _estimateSinglePose() async {
    final poseNet = await tf.load();
    final pose = await poseNet.estimateSinglePose(widget.videoElement);
    setState(() => _pose = pose);
    poseNet.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pose = _pose;
    if (pose == null) return const SizedBox();
    WidgetsBinding.instance.addPostFrameCallback((_) => _estimateSinglePose());

    final keypoint = pose.keypoints.firstWhere((k) => k.part == 'nose');
    final maskSize = Size(500, 500);
    return Positioned(
      left: (keypoint.position.x.toDouble() - 30) - (maskSize.width / 2),
      top: (keypoint.position.y.toDouble() - 20) - (maskSize.height / 2),
      child: SizedBox.fromSize(
        size: maskSize,
        child: _Bear(),
      ),
    );
  }
}

class _Bear extends StatefulWidget {
  const _Bear({Key? key}) : super(key: key);

  @override
  _BearState createState() => _BearState();
}

class _BearState extends State<_Bear> {
  SMIBool? _fail;

  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'Login Machine');
    artboard.addController(controller!);
    for (var input in controller.inputs) {
      print(input.name);
    }
    _fail = controller.findInput<bool>('isHandsUp') as SMIBool;
    print(_fail);
  }

  void _onTap() {
    print(_fail);
    _fail?.value = !_fail!.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: RiveAnimation.asset(
        'bear.rive',
        fit: BoxFit.cover,
        onInit: _onRiveInit,
      ),
    );
  }
}

class _BearRiveAnimationController extends StateMachineController {
  static StateMachineController? create(Artboard artboard) {
    for (final animation in artboard.animations) {
      if (animation is StateMachine && animation.name == 'Login Machine') {
        return StateMachineController(animation);
      }
    }
    return null;
  }

  _BearRiveAnimationController._(StateMachine stateMachine)
      : super(stateMachine);
}
