import 'package:camera/camera.dart';
import 'package:example/src/widgets/widgets.dart';
import 'package:face_geometry/face_geometry.dart';
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

  late final AudioPlayer _audioPlayer;
  var _isPlaying = false;
  FaceGeometry? _faceGeometry;

  void _onCameraReady(CameraController cameraController) {
    setState(() => _cameraController = cameraController);
  }

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    _audioPlayer = AudioPlayer();

    try {
      await _audioPlayer.setAsset('Lion_roar.mp3');
    } catch (_) {}
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AspectRatio(
        aspectRatio: _cameraController?.value.aspectRatio ?? 1,
        child: Stack(
          children: [
            Center(child: CameraView(onCameraReady: _onCameraReady)),
            if (_cameraController != null)
              FacesDetectorBuilder(
                cameraController: _cameraController!,
                builder: (context, faces) {
                  if (faces.isEmpty) return const SizedBox.shrink();
                  final face = faces.first;
                  final faceGeometry = _faceGeometry == null
                      ? FaceGeometry.fromFace(face)
                      : _faceGeometry!.update(face);
                  _faceGeometry = faceGeometry;

                  if (faceGeometry.mouth.isOpen) {
                    if (!_isPlaying) {
                      _audioPlayer.play();
                      _isPlaying = true;
                    }
                  } else {
                    _audioPlayer.pause();
                    _isPlaying = false;
                  }

                  return CustomPaint(
                    painter: _FaceLandmarkCustomPainter(
                      face: faces.first,
                      isMouthOpen: faceGeometry.mouth.isOpen,
                    ),
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
    required this.isMouthOpen,
  });

  final tf.Face face;
  final bool isMouthOpen;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isMouthOpen ? Colors.yellow : Colors.red
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
