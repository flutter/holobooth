import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:holobooth/camera/camera.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key, required this.onCameraReady, this.camera});

  @visibleForTesting
  static const cameraErrorViewKey = Key('camera_error_view');

  @visibleForTesting
  static const cameraLoadingKey = Key('cameraView_loading');

  @visibleForTesting
  static const cameraPreviewKey = Key('cameraView_cameraPreview');

  final void Function(CameraController controller)? onCameraReady;

  final CameraDescription? camera;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _cameraController;
  Completer<void>? _cameraControllerCompleter;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    _cameraControllerCompleter = Completer<void>();

    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(
        widget.camera ?? cameras[0],
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
        if (snapshot.hasError) {
          final error = snapshot.error;
          if (error is CameraException) {
            return CameraErrorView(error: error);
          } else {
            return const SizedBox.shrink(
              key: CameraView.cameraErrorViewKey,
            );
          }
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Builder(
            key: CameraView.cameraPreviewKey,
            builder: (_) => SizedBox.fromSize(
              size: Size.zero,
              child: _cameraController!.buildPreview(),
            ),
          );
        } else {
          return const SizedBox.shrink(key: CameraView.cameraLoadingKey);
        }
      },
    );
  }
}
