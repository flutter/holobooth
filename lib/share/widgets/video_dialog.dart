import 'package:flutter/material.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class VideoDialog extends StatelessWidget {
  const VideoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: PhotoboothColors.transparent,
      content: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(38),
          gradient: const LinearGradient(
            colors: <Color>[
              Color(0xFF9E81EF),
              Color(0xFF4100E0),
            ],
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF020320).withOpacity(0.95),
            borderRadius: BorderRadius.circular(38),
          ),
          child: VideoPlayerView(),
        ),
      ),
    );
  }
}
