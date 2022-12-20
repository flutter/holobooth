import 'package:flutter/material.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class VideoDialog extends StatelessWidget {
  const VideoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const HoloBoothAlertDialog(child: VideoPlayerView());
  }
}
