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
        const Align(child: PlayButton()),
      ],
    );
  }
}
