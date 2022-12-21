import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/rive/rive.dart';

class PhotoboothCharacter extends StatelessWidget {
  const PhotoboothCharacter({super.key});

  @override
  Widget build(BuildContext context) {
    final avatar =
        context.select((AvatarDetectorBloc bloc) => bloc.state.avatar);
    final hat =
        context.select((InExperienceSelectionBloc bloc) => bloc.state.hat);
    final glasses =
        context.select((InExperienceSelectionBloc bloc) => bloc.state.glasses);
    final clothes =
        context.select((InExperienceSelectionBloc bloc) => bloc.state.clothes);
    final handheldlLeft = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.handheldlLeft);
    final characterSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.character);

    switch (characterSelected) {
      case Character.dash:
        return DashAnimation(
          avatar: avatar,
          hat: hat,
          glasses: glasses,
          clothes: clothes,
          handheldlLeft: handheldlLeft,
        );
      case Character.sparky:
        return SparkyAnimation(
          avatar: avatar,
          hat: hat,
          glasses: glasses,
          clothes: clothes,
          handheldlLeft: handheldlLeft,
        );
    }
  }
}
