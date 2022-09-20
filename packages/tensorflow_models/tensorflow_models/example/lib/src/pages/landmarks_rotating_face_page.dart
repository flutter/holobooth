import 'dart:async';
import 'dart:math' as math;

// TODO(alestiago): Use a plugin instead.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:tensorflow_models/tensorflow_models.dart' as tf;
import 'package:vector_math/vector_math.dart' hide Colors;
import 'package:zflutter/zflutter.dart';

class LandmarksRotatingFacePage extends StatelessWidget {
  const LandmarksRotatingFacePage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LandmarksRotatingFacePage());

  @override
  Widget build(BuildContext context) => const _LandmarksRotatingFaceView();
}

class _LandmarksRotatingFaceView extends StatefulWidget {
  const _LandmarksRotatingFaceView({Key? key}) : super(key: key);

  @override
  State<_LandmarksRotatingFaceView> createState() =>
      _LandmarksRotatingFaceViewState();
}

class _LandmarksRotatingFaceViewState
    extends State<_LandmarksRotatingFaceView> {
  CameraController? _cameraController;
  html.VideoElement? _videoElement;

  void _onCameraReady(CameraController cameraController) {
    setState(() => _cameraController = cameraController);
    WidgetsBinding.instance.addPostFrameCallback((_) => _queryVideoElement());
    Future.delayed(
      Duration(seconds: 10),
      () => _cameraController!.pausePreview(),
    );
  }

  void _queryVideoElement() {
    final videoElement = html.querySelector('video')! as html.VideoElement;
    setState(() => _videoElement = videoElement);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AspectRatio(
        aspectRatio: _cameraController?.value.aspectRatio ?? 1,
        child: Stack(
          children: [
            _Camera(onCameraReady: _onCameraReady),
            if (_videoElement != null)
              LayoutBuilder(
                builder: (context, constraints) {
                  final size = constraints.biggest;
                  _videoElement!
                    ..width = size.width.floor()
                    ..height = size.height.floor();

                  return _FacesDetectorBuilder(
                    videoElement: _videoElement!,
                    builder: (context, faces) {
                      if (faces.isEmpty) return const SizedBox.shrink();
                      final face = faces.first;
                      final nose = face.keypoints[6];

                      return Stack(
                        children: [
                          SizedBox.fromSize(
                            size: size,
                            child: CustomPaint(
                              painter: _FaceLandmarkCustomPainter(
                                face: face,
                              ),
                            ),
                          ),
                          SizedBox.fromSize(
                            size: size,
                            child: _ZAxisArrowsIllustration(
                              face: face,
                              offset: -Offset(
                                (size.width / 2) - nose.x.toDouble(),
                                (size.height / 2) - nose.y.toDouble(),
                              ),
                            ),
                          ),
                        ],
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

class _Camera extends StatefulWidget {
  const _Camera({this.onCameraReady});

  final void Function(CameraController controller)? onCameraReady;

  @override
  State<_Camera> createState() => _CameraState();
}

class _CameraState extends State<_Camera> {
  late final CameraController _cameraController;
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
          } else {
            camera = Text('Unknown error: $error');
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

class _FacesDetectorBuilder extends StatefulWidget {
  const _FacesDetectorBuilder({
    required this.videoElement,
    required this.builder,
  });

  final html.VideoElement videoElement;

  final Widget Function(BuildContext context, tf.Faces faces) builder;

  @override
  State<_FacesDetectorBuilder> createState() => _FacesDetectorBuilderState();
}

class _FacesDetectorBuilderState extends State<_FacesDetectorBuilder> {
  late final tf.FaceLandmarksDetector _faceLandmarksDetector;
  tf.Faces? _faces;

  static const _estimationConfig = tf.EstimationConfig(
    flipHorizontal: true,
    staticImageMode: false,
  );

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _faceLandmarksDetector = await tf.TensorFlowFaceLandmarks.load();
    await _detect();
  }

  Future<void> _detect() async {
    final faces = await _faceLandmarksDetector.estimateFaces(
      widget.videoElement,
      estimationConfig: _estimationConfig,
    );
    setState(() => _faces = faces);

    WidgetsBinding.instance.addPostFrameCallback((_) => _detect());
  }

  @override
  void dispose() {
    _faceLandmarksDetector.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_faces == null) return const SizedBox.shrink();
    return widget.builder(context, _faces!);
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
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;
    final highlightPaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    for (final keypoint in face.keypoints) {
      final index = face.keypoints.indexOf(keypoint);
      final fooPaint =
          index == 127 || index == 6 || index == 356 ? highlightPaint : paint;
      final offset = Offset(keypoint.x.toDouble(), keypoint.y.toDouble());
      canvas.drawCircle(offset, 2, fooPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FaceLandmarkCustomPainter oldDelegate) =>
      face != oldDelegate.face;
}

class _ZAxisArrowsIllustration extends StatelessWidget {
  _ZAxisArrowsIllustration({
    required this.face,
    required this.offset,
  }) {
    // Computing the face rotation is a feature is still in development:
    // https://github.com/tensorflow/tfjs/issues/3835#issuecomment-1109111171

    final leftCheeck = face.keypoints[127];
    final rightCheeck = face.keypoints[356];
    final nose = face.keypoints[6];

    // final distanceToNose = Vector3(
    //   (nose.x - leftCheeck.x).toDouble(),
    //   (nose.y - leftCheeck.y).toDouble(),
    //   (nose.z! - leftCheeck.z!).toDouble(),
    // );
    // final distanceBetweenCheecks = Vector3(
    //   (rightCheeck.x - leftCheeck.x).toDouble(),
    //   (rightCheeck.y - leftCheeck.y).toDouble(),
    //   (rightCheeck.z! - leftCheeck.z!).toDouble(),
    // );
    // final perpendicular = distanceToNose.cross(distanceBetweenCheecks);

    // _vectorX = distanceBetweenCheecks.normalized();
    // _vectorY = perpendicular.normalized();
    // _vectorZ = _vectorX.cross(_vectorY).normalized();
    final bottomX = (rightCheeck.x + leftCheeck.x) / 2;
    final bottomY = (rightCheeck.y + leftCheeck.y) / 2;
    _degree = math.atan((nose.y - bottomY) / (nose.x - bottomX));
  }

  final tf.Face face;

  final Offset offset;

  // late final Vector3 _vectorX;
  // late final Vector3 _vectorY;
  // late final Vector3 _vectorZ;
  late final double _degree;

  @override
  Widget build(BuildContext context) {
    const length = 100.0;

    return ZIllustration(
      children: [
        ZPositioned(
          translate: ZVector.only(x: offset.dx, y: offset.dy),
          rotate: ZVector.only(x: _degree),
          child: ZGroup(
            children: [
              ZShape(
                color: Colors.red,
                stroke: 10,
                path: [
                  ZMove(0, 0, 0),
                  ZLine(length, 0, 0),
                ],
              ),
              ZShape(
                color: Colors.green,
                stroke: 10,
                path: [
                  ZMove(0, 0, 0),
                  ZLine(0, length, 0),
                ],
              ),
              ZShape(
                color: Colors.blue,
                stroke: 10,
                path: [
                  ZMove(0, 0, 0),
                  ZLine(0, 0, length),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

Matrix3 _calculateRotationMatrix(tf.Face face) {
  // Math calculations extractred from the following pull request, see https://github.com/tensorflow/tfjs-models/pull/844/files/.
  final leftCheeck = face.keypoints[127];
  final rightCheeck = face.keypoints[356];
  final nose = face.keypoints[6];

  final distanceToNose = Vector3(
    (nose.x - leftCheeck.x).toDouble(),
    (nose.y - leftCheeck.y).toDouble(),
    (nose.z! - leftCheeck.z!).toDouble(),
  );
  final distanceBetweenCheecks = Vector3(
    (rightCheeck.x - leftCheeck.x).toDouble(),
    (rightCheeck.y - leftCheeck.y).toDouble(),
    (rightCheeck.z! - leftCheeck.z!).toDouble(),
  );
  final perpendicular = distanceToNose.cross(distanceBetweenCheecks);

  final vectorX = distanceBetweenCheecks.normalized();
  final vectorY = perpendicular.normalized();
  final vectorZ = vectorX.cross(vectorY).normalized();
  return Matrix3.zero()
    ..row0.x = vectorX.x
    ..row0.y = vectorY.x
    ..row0.z = vectorZ.x
    ..row1.x = vectorX.y
    ..row1.y = vectorY.y
    ..row1.z = vectorZ.y
    ..row2.x = vectorX.z
    ..row2.y = vectorY.z
    ..row2.z = vectorZ.z;
}
