import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';

class AvatarDetector extends StatelessWidget {
  const AvatarDetector({
    super.key,
    required this.cameraController,
    required this.child,
  });

  final CameraController cameraController;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AvatarDetectorBloc, AvatarDetectorState>(
      listener: (context, state) async {
        if (state is AvatarDetectorLoaded) {
          await cameraController.startImageStream((image) {
            context
                .read<AvatarDetectorBloc>()
                .add(AvatarDetectorEstimateRequested(image));
          });
        }
      },
      builder: (context, state) {
        if (state is AvatarDetectorFacesDetected) {
          return child;
        }
        return const SizedBox.shrink();
      },
    );
  }
}
