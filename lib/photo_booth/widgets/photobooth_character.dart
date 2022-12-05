import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/rive/rive.dart';

class PhotoboothCharacter extends StatelessWidget {
  const PhotoboothCharacter({super.key});

  @override
  Widget build(BuildContext context) {
    final avatar = context.select(
      (AvatarDetectorBloc bloc) => bloc.state.avatar,
    );
    final propSelected = context.select(
      (InExperienceSelectionBloc bloc) => bloc.state.selectedProps,
    );

    // TODO(alestiago): Check out if normalizations is sufficient for all
    // characters and devices.
    final adjustedDistance = (avatar.distance * 5) + 0.5;

    // TODO(oscar): check from bloc which character is selected.
    return AnimatedScale(
      scale: adjustedDistance.clamp(0.5, 1),
      duration: const Duration(milliseconds: 50),
      child: DashAnimation(
        avatar: avatar,
        propsSelected: propSelected,
      ),
    );
  }
}
