import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';
import 'package:holobooth/rive/rive.dart';
import 'package:platform_helper/platform_helper.dart';
import 'package:rive/rive.dart';

class PhotoboothBackground extends StatefulWidget {
  PhotoboothBackground({super.key, PlatformHelper? platformHelper})
      : platformHelper = platformHelper ?? PlatformHelper();

  final PlatformHelper platformHelper;

  @override
  State<PhotoboothBackground> createState() => _PhotoboothBackgroundState();
}

class _PhotoboothBackgroundState extends State<PhotoboothBackground> {
  final Map<Background, RiveFile> _backgrounds = {};

  @override
  void initState() {
    super.initState();

    if (!widget.platformHelper.isMobile) {
      for (final background in Background.values) {
        loadBackground(background)
            .then((file) => setState(() => _backgrounds[background] = file));
      }
    }
  }

  Future<RiveFile> loadBackground(Background background) async {
    final RiveGenImage riveAsset;
    switch (background) {
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

    return RiveFile.asset(riveAsset.keyName);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.background);

    final riveFile = _backgrounds[backgroundSelected];

    if (widget.platformHelper.isMobile || riveFile == null) {
      return Image(
        key: Key(backgroundSelected.name),
        image: backgroundSelected.toImageProvider(),
        fit: BoxFit.cover,
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: BackgroundAnimation(
        key: Key(backgroundSelected.name),
        riveFile: riveFile,
      ),
    );
  }
}
