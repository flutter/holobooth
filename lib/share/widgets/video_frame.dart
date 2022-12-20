import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/share/share.dart';

class VideoFrame extends StatelessWidget {
  const VideoFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: Assets.backgrounds.videoFrame.image()),
        Align(
          child: IconButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (context) => const VideoDialog(),
              );
            },
            color: Colors.white,
            iconSize: 45,
            icon: const Icon(Icons.play_arrow),
          ),
        ),
      ],
    );
  }
}
