import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({super.key});
  static const dimension = 65.0;

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
            builder: (_) => const VideoDialog(),
          );
        },
        child: SizedBox.square(
          dimension: dimension,
          child: Assets.icons.playIcon.image(),
        ),
      ),
    );
  }
}
