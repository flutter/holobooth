import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/rive/rive.dart';

class PhotoboothCharacter extends StatefulWidget {
  const PhotoboothCharacter({super.key});

  @override
  State<PhotoboothCharacter> createState() => _PhotoboothCharacterState();
}

class _PhotoboothCharacterState extends State<PhotoboothCharacter> {
  Avatar? _latestValidAvatar;

  @override
  Widget build(BuildContext context) {
    final avatar =
        context.select((AvatarDetectorBloc bloc) => bloc.state.avatar);
    if (avatar.isValid) _latestValidAvatar = avatar;

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

    late final CharacterAnimation character;
    switch (characterSelected) {
      case Character.dash:
        character = DashCharacterAnimation(
          avatar: _latestValidAvatar ?? Avatar.zero,
          hat: hat,
          glasses: glasses,
          clothes: clothes,
          handheldlLeft: handheldlLeft,
        );
        break;
      case Character.sparky:
        character = SparkyCharacterAnimation(
          avatar: _latestValidAvatar ?? Avatar.zero,
          hat: hat,
          glasses: glasses,
          clothes: clothes,
          handheldlLeft: handheldlLeft,
        );
        break;
    }

    return AnimatedOpacity(
      opacity: avatar.isValid ? 1 : 0.8,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOutBack,
      child: character,
    );
  }
}
