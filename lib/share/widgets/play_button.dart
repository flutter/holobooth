import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          final videoPath = context.read<ShareBloc>().state.videoPath;
          showDialog<void>(
            context: context,
            builder: (_) => VideoDialog(videoPath: videoPath),
          );
        },
        child: SizedBox.square(
          dimension: 100,
          child: Assets.icons.playIcon.image(),
        ),
      ),
    );
  }
}
