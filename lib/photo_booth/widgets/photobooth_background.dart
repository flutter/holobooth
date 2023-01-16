import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/rive/rive.dart';

class PhotoboothBackground extends StatelessWidget {
  const PhotoboothBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.background);

    RiveGenImage riveAsset;

    switch (backgroundSelected) {
      case Background.bg00:
        riveAsset = Assets.animations.bg00;
        break;
      case Background.bg01:
        riveAsset = Assets.animations.bg01;
        break;
      case Background.bg02:
        riveAsset = Assets.animations.bg02;
        break;
      case Background.bg03:
        riveAsset = Assets.animations.bg03;
        break;
      case Background.bg04:
        riveAsset = Assets.animations.bg04;
        break;
      case Background.bg05:
        riveAsset = Assets.animations.bg05;
        break;
      case Background.bg06:
        riveAsset = Assets.animations.bg06;
        break;
      case Background.bg07:
        riveAsset = Assets.animations.bg07;
        break;
      case Background.bg08:
        riveAsset = Assets.animations.bg08;
        break;
    }
    return BackgroundAnimation(
      key: Key(backgroundSelected.name),
      riveGenImage: riveAsset,
    );
  }
}
