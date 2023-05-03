import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/avatar_detector/avatar_detector.dart';

class CameraStreamListener extends StatefulWidget {
  const CameraStreamListener({
    required this.cameraController,
    super.key,
  });

  final CameraController cameraController;

  @override
  State<CameraStreamListener> createState() => _CameraStreamListenerState();
}

class _CameraStreamListenerState extends State<CameraStreamListener> {
  @override
  void initState() {
    super.initState();
    widget.cameraController.startImageStream((image) {
      context
          .read<AvatarDetectorBloc>()
          .add(AvatarDetectorEstimateRequested(image));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
