import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/share/share.dart';

class VideoFrame extends StatelessWidget {
  const VideoFrame({super.key});

  @override
  Widget build(BuildContext context) {
    final thumbnail = context.read<ConvertBloc>().state.firstFrameProcessed;
    return AspectRatio(
      // There is no better way to determine the size of an image without
      // decoding the image, so if image ratio changes this value
      // should be updated.
      aspectRatio: 404 / 515,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (thumbnail != null)
            LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  // These values are calculated from the image.
                  padding: EdgeInsets.fromLTRB(
                    104 / 1617 * constraints.maxWidth,
                    105 / 2065 * constraints.maxHeight,
                    93 / 1617 * constraints.maxWidth,
                    381 / 2065 * constraints.maxHeight,
                  ),
                  child: Image.memory(
                    thumbnail.buffer.asUint8List(),
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          Assets.backgrounds.videoFrame.image(),
          const Center(child: PlayButton()),
        ],
      ),
    );
  }
}
