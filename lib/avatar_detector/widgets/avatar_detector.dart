import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/rive/rive.dart';

class AvatarDetector extends StatefulWidget {
  const AvatarDetector({
    super.key,
    required this.cameraController,
  });

  final CameraController cameraController;

  static const loadingKey = Key('loading_sizedBox');

  @override
  State<AvatarDetector> createState() => _AvatarDetectorState();
}

class _AvatarDetectorState extends State<AvatarDetector> {
  @override
  void initState() {
    super.initState();
    widget.cameraController.startImageStream((image) {
      // TODO(alestiago): Refactor with task:
      // https://very-good-ventures-team.monday.com/boards/3161754080/pulses/3532736865
      final bloc = context.read<AvatarDetectorBloc>();
      if (bloc.state is! AvatarDetectorInitial ||
          bloc.state is! AvatarDetectorLoading) {
        bloc.add(AvatarDetectorEstimateRequested(image));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvatarDetectorBloc, AvatarDetectorState>(
      builder: (context, state) {
        return state is AvatarDetectorDetected
            ? DashAnimation(avatar: state.avatar)
            : const SizedBox(key: AvatarDetector.loadingKey);
      },
    );
  }
}
