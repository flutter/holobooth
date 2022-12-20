import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/share/share.dart';

class VideoFrame extends StatelessWidget {
  const VideoFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.fill,
            child: VideoPlayerView(),
          ),
        ),
        //FURTHER IMPLEMENTATION
      ],
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: Assets.backgrounds.videoFrame.image()),
        Align(
          child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return VideoDialog();
                  },
                );
              },
              color: Colors.white,
              iconSize: 45,
              icon: Icon(Icons.play_arrow)),
        ),
      ],
    );
  }
}
