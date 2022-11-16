import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/rive/rive.dart';

class PhotoboothBackground extends StatelessWidget {
  const PhotoboothBackground({super.key});

  static const loadingKey = Key('loading');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvatarDetectorBloc, AvatarDetectorState>(
      builder: (context, state) {
        return state is AvatarDetectorDetected
            ? SpaceBackground.fromVector3(state.avatar.direction)
            : const SizedBox.expand(key: PhotoboothBackground.loadingKey);
      },
    );
  }
}
