import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/share/share.dart';

class VideoFrame extends StatelessWidget {
  const VideoFrame({super.key});

  @override
  Widget build(BuildContext context) {
    final thumbnail = context.read<ShareBloc>().state.thumbnail;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: Assets.backgrounds.videoFrame.image()),
        if (thumbnail != null)
          Positioned(child: Image.memory(thumbnail.buffer.asUint8List())),
        const Align(child: PlayButton()),
      ],
    );
  }
}
