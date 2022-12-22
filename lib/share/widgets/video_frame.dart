import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/share/share.dart';

class VideoFrame extends StatelessWidget {
  const VideoFrame({super.key, required this.isSmallScreen});

  final bool isSmallScreen;

  @override
  Widget build(BuildContext context) {
    final thumbnail = context.read<ShareBloc>().state.thumbnail;

    return AspectRatio(
      aspectRatio: 404 / 515,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (thumbnail != null)
            Positioned.fill(
              child: Image.memory(
                thumbnail.buffer.asUint8List(),
                fit: BoxFit.cover,
              ),
            ),
          Positioned.fill(child: Assets.backgrounds.videoFrame.image()),
          const Align(child: PlayButton()),
        ],
      ),
    );
  }
}
