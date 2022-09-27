import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    super.key,
    this.onCameraReady,
    this.errorBuilder,
  });

  final void Function(CameraController controller)? onCameraReady;
  final Widget Function(BuildContext context, Object? error)? errorBuilder;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  CameraController? _cameraController;
  Completer<void>? _cameraControllerCompleter;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    _cameraControllerCompleter = Completer<void>();

    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.max,
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
      _cameraController = null;
    } else if (state == AppLifecycleState.resumed &&
        _cameraController == null) {
      _initializeCamera();
      setState(() {});
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
          camera = widget.errorBuilder?.call(context, error) ??
              const SizedBox.shrink();
        } else if (snapshot.connectionState == ConnectionState.done) {
          camera = _cameraController!.buildPreview();
        } else {
          camera = const SizedBox.shrink();
        }
        return camera;
      },
    );
  }
}
