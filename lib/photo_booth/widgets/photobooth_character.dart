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

    final propSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.selectedProps);

    // TODO(alestiago): Instead of directly using avatar.distance consider
    // adding logic to define a maximum, minimum and a normal distance.
    return AnimatedScale(
      scale: avatar.distance,
      duration: const Duration(milliseconds: 200),
      child: DashAnimation(
        avatar: avatar,
        propsSelected: propSelected,
      ),
    );
  }
}
