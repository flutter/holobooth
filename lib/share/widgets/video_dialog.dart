import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/share/share.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class VideoDialogLauncher extends StatelessWidget {
  const VideoDialogLauncher({
    required this.convertBloc,
    super.key,
  });

  final ConvertBloc convertBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConvertBloc, ConvertState>(
      bloc: convertBloc,
      builder: (_, state) {
        if (state.status == ConvertStatus.videoCreated) {
          return VideoDialog(videoPath: state.videoPath);
        }

        return const Center(
          child: SizedBox.square(
            dimension: 96,
            child: CircularProgressIndicator(
              color: HoloBoothColors.convertLoading,
            ),
          ),
        );
      },
    );
  }
}

class VideoDialog extends StatefulWidget {
  const VideoDialog({required this.videoPath, super.key});

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
