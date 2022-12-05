import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/rive/rive.dart';

class PhotoboothBackground extends StatelessWidget {
  const PhotoboothBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final avatar = context.select(
      (AvatarDetectorBloc bloc) => bloc.state.avatar,
    );
    final backgroundSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.background);

    return BackgroundAnimation(
      x: avatar.direction.x,
      y: avatar.direction.y,
      z: 0,
      backgroundSelected: backgroundSelected,
    );
  }
}
