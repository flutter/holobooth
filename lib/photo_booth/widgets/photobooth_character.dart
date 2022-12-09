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

    final hatSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.selectedHat);

    // TODO(alestiago): Check out if normalizations is sufficient for all
    // characters and devices.
    final normalizedDistance = avatar.distance.normalize(
      fromMin: 0,
      fromMax: 1,
      toMin: 0.5,
      toMax: 1,
    );

    // TODO(oscar): check from bloc which character is selected.
    return AnimatedScale(
      scale: normalizedDistance,
      duration: const Duration(milliseconds: 200),
      child: DashAnimation(
        avatar: avatar,
        hatSelected: hatSelected,
      ),
    );
  }
}

extension NormalizeNumber on num {
  double normalize({
    required num fromMin,
    required num fromMax,
    required num toMin,
    required num toMax,
  }) {
    assert(fromMin < fromMax, 'fromMin must be smaller than fromMax');
    assert(toMin < toMax, 'toMin must be smaller than toMax');
    return (toMax - toMin) * ((this - fromMin) / (fromMax - fromMin)) + toMin;
  }
}
