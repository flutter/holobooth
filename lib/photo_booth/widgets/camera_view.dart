import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    super.key,
    required this.onCameraReady,
    required this.errorBuilder,
  });

  @visibleForTesting
  static const loadingKey = Key('cameraView_loading');

  @visibleForTesting
  static const cameraPreviewKey = Key('cameraView_cameraPreview');

  final void Function(CameraController controller)? onCameraReady;
  final Widget Function(BuildContext context, Object? error) errorBuilder;

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
          camera = widget.errorBuilder.call(context, error);
        } else if (snapshot.connectionState == ConnectionState.done) {
          camera = Builder(
            key: CameraView.cameraPreviewKey,
            builder: (_) => _cameraController!.buildPreview(),
          );
        } else {
          camera = const SizedBox.shrink(key: CameraView.loadingKey);
        }
        return camera;
      },
    );
  }
}
