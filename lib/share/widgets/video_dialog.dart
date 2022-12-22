import 'package:flutter/material.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

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
      child: HoloBoothAlertDialog(
        child: VideoPlayerView(
          url: widget.videoPath,
          onInitialized: () {
            setState(() {
              videoInitialized = true;
            });
          },
        ),
      ),
    );
  }
}
