import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/avatar_detector/avatar_detector.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';
import 'package:holobooth/rive/rive.dart';

class PhotoboothCharacter extends StatefulWidget {
  const PhotoboothCharacter({super.key});

  @override
  State<PhotoboothCharacter> createState() => PhotoboothCharacterState();
}

@visibleForTesting
class PhotoboothCharacterState extends State<PhotoboothCharacter> {
  Avatar _latestValidAvatar = Avatar.zero;
  final _sparky = RiveCharacter.sparky();
  final _dash = RiveCharacter.dash();

  late final Future<void> charactersReady;

  @override
  void initState() {
    super.initState();

    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    final riveFileManager = context.read<RiveFileManager>();
    final sparkyReady =
        _sparky.load(riveFileManager).then((_) => setState(() {}));
    final dashReady = _dash.load(riveFileManager).then((_) => setState(() {}));
    charactersReady = Future.wait([dashReady, sparkyReady]);
  }

  @override
  Widget build(BuildContext context) {
    final avatarStatus =
        context.select((AvatarDetectorBloc bloc) => bloc.state.status);
    final avatar =
        context.select((AvatarDetectorBloc bloc) => bloc.state.avatar);
    if (avatarStatus == AvatarDetectorStatus.detected) {
      _latestValidAvatar = avatar;
    }
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

    final RiveCharacter character;
    switch (characterSelected) {
      case Character.dash:
        character = _dash;
        break;
      case Character.sparky:
        character = _sparky;
        break;
    }

    if (!character.isLoaded) {
      return const SizedBox.shrink();
    }

    return AnimatedOpacity(
      opacity: avatarStatus == AvatarDetectorStatus.notDetected ? 0.8 : 1,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOutBack,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: CharacterAnimation(
          key: ValueKey(character),
          riveCharacter: character,
          avatar: _latestValidAvatar,
          hat: hat,
          glasses: glasses,
          clothes: clothes,
          handheldlLeft: handheldlLeft,
        ),
      ),
    );
  }
}
