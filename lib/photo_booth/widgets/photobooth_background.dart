import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';
import 'package:holobooth/rive/rive.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
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
  @override
  void initState() {
    super.initState();

    if (!widget.platformHelper.isMobile) {
      for (final background in Background.values) {
        loadBackground(background).then((file) => setState(() {}));
      }
    }
  }

  Future<RiveFile> loadBackground(Background background) async {
    final backgroundPath = pathForBackground(background);
    return context.read<RiveFileManager>().loadFile(backgroundPath);
  }

  RiveFile? getBackground(Background background) {
    final riveFileManager = context.read<RiveFileManager>();
    final backgroundPath = pathForBackground(background);
    return riveFileManager.getFile(backgroundPath);
  }

  String pathForBackground(Background background) {
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

    return riveAsset.path;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundSelected = context
        .select((InExperienceSelectionBloc bloc) => bloc.state.background);

    final riveFile = getBackground(backgroundSelected);
    final Widget child;
    if (widget.platformHelper.isMobile || riveFile == null) {
      child = Image(
        key: Key(backgroundSelected.name),
        image: backgroundSelected.toImageProvider(),
        fit: BoxFit.cover,
      );
    } else {
      child = BackgroundAnimation(
        key: Key(backgroundSelected.name),
        riveFile: riveFile,
      );
    }

    return ColoredBox(
      color: HoloBoothColors.background,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: child,
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
      ),
    );
  }
}
