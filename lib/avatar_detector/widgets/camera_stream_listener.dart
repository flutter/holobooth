import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';

class CameraStreamListener extends StatefulWidget {
  const CameraStreamListener({
    super.key,
    required this.cameraController,
  });

  final CameraController cameraController;

  @override
  State<CameraStreamListener> createState() => _AvatarDeState();
}

class _AvatarDeState extends State<CameraStreamListener> {
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
