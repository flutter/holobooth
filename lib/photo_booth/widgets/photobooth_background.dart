import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';
import 'package:holobooth/rive/rive.dart';

class PhotoboothBackground extends StatelessWidget {
  const PhotoboothBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.background);

    RiveGenImage riveAsset;

    switch (backgroundSelected) {
      case Background.bg0:
        riveAsset = Assets.animations.bg00;
        break;
      case Background.bg1:
        riveAsset = Assets.animations.bg01;
        break;
      case Background.bg2:
        riveAsset = Assets.animations.bg02;
        break;
      case Background.bg3:
        riveAsset = Assets.animations.bg03;
        break;
      case Background.bg4:
        riveAsset = Assets.animations.bg04;
        break;
      case Background.bg5:
        riveAsset = Assets.animations.bg05;
        break;
      case Background.bg6:
        riveAsset = Assets.animations.bg06;
        break;
      case Background.bg7:
        riveAsset = Assets.animations.bg07;
        break;
      case Background.bg8:
        riveAsset = Assets.animations.bg08;
        break;
    }
    return AnimatedSwitcher(
      duration: const Duration(seconds: 3),
      child: BackgroundAnimation(
        key: Key(backgroundSelected.name),
        riveGenImage: riveAsset,
      ),
    );
  }
}
