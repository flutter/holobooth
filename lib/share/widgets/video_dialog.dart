import 'package:flutter/material.dart';
import 'package:holobooth/share/share.dart';

class VideoDialog extends StatefulWidget {
  const VideoDialog({super.key, required this.videoPath});

  final String videoPath;

  @override
  State<VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  bool videoInitialized = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: videoInitialized ? 1 : 0,
      duration: const Duration(milliseconds: 400),
      child: VideoPlayerView(
        url: widget.videoPath,
        onInitialized: () {
          setState(() {
            videoInitialized = true;
          });
        },
      ),
    );
  }
}
