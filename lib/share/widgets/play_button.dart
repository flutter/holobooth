import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PhotoboothColors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (context) => const VideoDialog(),
          );
        },
        child: Assets.icons.playIcon.image(height: 65),
      ),
    );
    return IconButton(
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (context) => const VideoDialog(),
        );
      },
      color: Colors.white,
      iconSize: 65,
      icon: Assets.icons.playIcon.image(),
    );
  }
}
