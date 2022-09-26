// TODO(alestiago): Use a plugin instead.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:math' as math;

import 'package:audio_session/audio_session.dart';
import 'package:camera/camera.dart';
import 'package:example/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class LandmarksOpenMouthPage extends StatelessWidget {
  const LandmarksOpenMouthPage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LandmarksOpenMouthPage());

  @override
  Widget build(BuildContext context) => const _LandmarksOpenMouthPage();
}

class _LandmarksOpenMouthPage extends StatefulWidget {
  const _LandmarksOpenMouthPage({Key? key}) : super(key: key);

  @override
  State<_LandmarksOpenMouthPage> createState() =>
      _LandmarksOpenMouthPageState();
}

class _LandmarksOpenMouthPageState extends State<_LandmarksOpenMouthPage> {
  CameraController? _cameraController;
  html.VideoElement? _videoElement;

  late final AudioPlayer audioPlayer;

  void _onCameraReady(CameraController cameraController) {
    setState(() => _cameraController = cameraController);
    WidgetsBinding.instance.addPostFrameCallback((_) => _queryVideoElement());
  }

  void _queryVideoElement() {
    final videoElement = html.querySelector('video')! as html.VideoElement;
    setState(() => _videoElement = videoElement);
  }

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    audioPlayer = AudioPlayer();
    final audioSession = await AudioSession.instance;

    try {
      await audioSession.configure(const AudioSessionConfiguration.speech());
    } catch (_) {}

    try {
      await audioPlayer.setAsset('Lion_roar.mp3');
    } catch (_) {}
    audioPlayer.playerStateStream.listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AspectRatio(
        aspectRatio: _cameraController?.value.aspectRatio ?? 1,
        child: Stack(
          children: [
            CameraView(onCameraReady: _onCameraReady),
            if (_videoElement != null)
              LayoutBuilder(
                builder: (context, constraints) {
                  final size = constraints.biggest;
                  _videoElement!
                    ..width = size.width.floor()
                    ..height = size.height.floor();

                  return FacesDetectorBuilder(
                    videoElement: _videoElement!,
                    builder: (context, faces) {
                      if (faces.isEmpty) return const SizedBox.shrink();
                      if (faces.first.isMouthOpened()) {
                        audioPlayer.play();
                      } else if (!faces.first.isMouthOpened()) {
                        audioPlayer.pause();
                      }

                      return SizedBox.fromSize(
                        size: size,
                        child: CustomPaint(
                          painter: _FaceLandmarkCustomPainter(
                            face: faces.first,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _FaceLandmarkCustomPainter extends CustomPainter {
  const _FaceLandmarkCustomPainter({
    required this.face,
  });

  final tf.Face face;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = face.isMouthOpened() ? Colors.yellow : Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    for (final keypoint in face.keypoints) {
      if (!(keypoint.name?.contains('lips') ?? false)) continue;
      final offset = Offset(keypoint.x.toDouble(), keypoint.y.toDouble());
      canvas.drawCircle(offset, 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FaceLandmarkCustomPainter oldDelegate) =>
      face != oldDelegate.face;
}

extension on tf.Face {
  bool isMouthOpened() {
    final topLipPoint = keypoints[13];
    final bottomLipPoint = keypoints[14];
    final dx = topLipPoint.x - bottomLipPoint.x;
    final dy = topLipPoint.y - bottomLipPoint.y;
    final distance = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
    return distance > 1;
  }
}
