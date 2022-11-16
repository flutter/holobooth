import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/avatar_animation/avatar_animation.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';

class AvatarDetector extends StatelessWidget {
  const AvatarDetector({
    super.key,
    required this.cameraController,
  });
  final CameraController cameraController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AvatarDetectorBloc(context.read<AvatarDetectorRepository>())
            ..add(const AvatarDetectorInitialized()),
      child: AvatarDetectorContent(cameraController: cameraController),
    );
  }
}

@visibleForTesting
class AvatarDetectorContent extends StatelessWidget {
  const AvatarDetectorContent({
    super.key,
    required this.cameraController,
  });

  final CameraController cameraController;

  static const loadingKey = Key('loading_sizedBox');

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AvatarDetectorBloc, AvatarDetectorState>(
      listenWhen: (previous, current) => current is AvatarDetectorLoaded,
      listener: (context, state) async {
        await cameraController.startImageStream((image) {
          context
              .read<AvatarDetectorBloc>()
              .add(AvatarDetectorEstimateRequested(image));
        });
      },
      builder: (context, state) => state is AvatarDetectorDetected
          ? Stack(
              fit: StackFit.expand,
              children: [
                SpaceBackground.fromVector3(state.avatar.direction),
                DashAnimation(avatar: state.avatar),
              ],
            )
          : const SizedBox(key: loadingKey),
    );
  }
}
