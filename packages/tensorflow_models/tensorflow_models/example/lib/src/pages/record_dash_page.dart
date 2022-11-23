import 'dart:async';

import 'package:camera/camera.dart';
import 'package:example/src/src.dart';
import 'package:example/src/widgets/dash.dart';
import 'package:example/src/widgets/dash_with_background.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:screen_recorder/screen_recorder.dart';

class RecordDashPage extends StatelessWidget {
  const RecordDashPage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const RecordDashPage());

  @override
  Widget build(BuildContext context) => const _RecordDashView();
}

class _RecordDashView extends StatefulWidget {
  const _RecordDashView({Key? key}) : super(key: key);

  @override
  State<_RecordDashView> createState() => _RecordDashViewState();
}

class _RecordDashViewState extends State<_RecordDashView> {
  CameraController? _cameraController;
  FaceGeometry? _faceGeometry;
  bool _displayDashBackground = true;
  late TextEditingController _pixelRatioContoller;
  late TextEditingController _framesContoller;
  ScreenRecorderController? screenRecorderController;
  var _isCameraVisible = false;
  bool isRecording = false;
  XFile? currentGif;

  void _onCameraReady(CameraController cameraController) {
    setState(() {
      _cameraController = cameraController;
      _pixelRatioContoller = TextEditingController(text: '0.5');
      _framesContoller = TextEditingController(text: '0');
      _setUpScreenContoller();
    });
  }

  void _setUpScreenContoller() {
    screenRecorderController = ScreenRecorderController(
      skipFramesBetweenCaptures: int.tryParse(_framesContoller.text) ?? 2,
      pixelRatio: double.tryParse(_pixelRatioContoller.text) ?? 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            _displayDashBackground = !_displayDashBackground;
          });
        },
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0,
            child: CameraView(onCameraReady: _onCameraReady),
          ),
          if (_cameraController != null) ...[
            FacesDetectorBuilder(
              cameraController: _cameraController!,
              builder: (context, faces) {
                if (faces.isEmpty) {
                  if (_faceGeometry == null) {
                    return const SizedBox();
                  }
                } else {
                  final face = faces.first;
                  _faceGeometry = _faceGeometry == null
                      ? FaceGeometry.fromFace(face)
                      : _faceGeometry!.update(face);
                }

                return Stack(
                  children: [
                    if (_displayDashBackground)
                      DashWithBackground(
                        faceGeometry: _faceGeometry,
                        screenRecorderController: screenRecorderController,
                      )
                    else
                      Center(
                        child: Dash(
                          faceGeometry: _faceGeometry!,
                          screenRecorderController: screenRecorderController!,
                        ),
                      ),
                    FaceGeometryOverlay(faceGeometry: _faceGeometry!),
                  ],
                );
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isCameraVisible = !_isCameraVisible;
                        });
                      },
                      child: Text(
                        _isCameraVisible
                            ? 'Hide the camera'
                            : 'Show the camera',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (isRecording) {
                          screenRecorderController?.stop();
                          await _showDialog();
                        } else {
                          setState(() {
                            isRecording = true;
                          });
                          _setUpScreenContoller();
                          screenRecorderController?.start();
                        }
                      },
                      child: Text(
                        isRecording ? 'stop recording' : 'start recording',
                      ),
                    ),
                    const SizedBox(height: 10),
                    _Timer(isRecording: isRecording),
                    const SizedBox(height: 10),
                    _TextField(
                      label: 'Pixel ratio',
                      controller: _pixelRatioContoller,
                    ),
                    const SizedBox(height: 10),
                    _TextField(
                      label: 'Skip frames',
                      controller: _framesContoller,
                    ),
                  ],
                ),
              ),
            )
          ]
        ],
      ),
    );
  }

  Future<void> _showDialog() async {
    final now = DateTime.now();
    final fileName = 'dash_'
        'skip_ratio${_pixelRatioContoller.text}'
        '_skip${_framesContoller.text}'
        '.gif';

    try {
      currentGif = await screenRecorderController?.compositeGif(fileName);
      await currentGif?.saveTo('');
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
    final file = await currentGif?.readAsBytes();
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            children: [
              Text(
                'gif inMilliseconds '
                '${DateTime.now().difference(now).inMilliseconds}',
              ),
              if (file != null) Image.memory(file) else const SizedBox.shrink(),
            ],
          ),
        );
      },
    ).then(
      (_) => {
        setState(() {
          isRecording = false;
        })
      },
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({Key? key, required this.label, required this.controller})
      : super(key: key);

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}

class _Timer extends StatefulWidget {
  const _Timer({
    Key? key,
    required this.isRecording,
  }) : super(key: key);

  final bool isRecording;

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<_Timer> {
  Timer? _timer;
  double _time = 0;

  @override
  void didUpdateWidget(covariant _Timer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isRecording) {
      _timer = Timer.periodic(
        const Duration(milliseconds: 500),
        (Timer timer) {
          setState(() {
            _time += 0.5;
          });
        },
      );
    } else {
      _time = 0;
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Text('time ${_time.toStringAsPrecision(2)}'),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
