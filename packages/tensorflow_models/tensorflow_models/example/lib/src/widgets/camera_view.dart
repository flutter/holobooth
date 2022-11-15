import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key, this.onCameraReady}) : super(key: key);

  /// Callback called once the camera has been initialized.
  ///
  /// **NOTE**: There is no need to dispose the controller since [CameraView]
  /// disposes it.
  final void Function(CameraController controller)? onCameraReady;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late final CameraController? _cameraController;
  late final Completer<void>? _cameraControllerCompleter;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    try {
      _cameraController?.stopImageStream();
    } catch (_) {}
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    _cameraControllerCompleter = Completer<void>();

    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _cameraController?.initialize();
      widget.onCameraReady?.call(_cameraController!);
      _cameraControllerCompleter?.complete();
    } catch (error) {
      _cameraControllerCompleter?.completeError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _cameraControllerCompleter?.future,
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
          camera = _cameraController!.buildPreview();
        } else {
          camera = const CircularProgressIndicator();
        }
        return camera;
      },
    );
  }
}
