import 'package:flutter/material.dart';
import 'package:io_photobooth/share/share.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (context) => const VideoDialog(),
        );
      },
      color: Colors.white,
      iconSize: 45,
      icon: const Icon(Icons.play_arrow),
    );
  }
}
