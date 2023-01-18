import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/share/share.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class ConvertFinished extends StatelessWidget {
  const ConvertFinished({
    super.key,
    required this.dimension,
  });

  final double dimension;

  void _finishConvert(BuildContext context) {
    final convertBloc = context.read<ConvertBloc>();
    final state = convertBloc.state;
    Navigator.of(context).push(
      SharePage.route(
        videoPath: state.videoPath,
        firstFrame: state.firstFrameProcessed ?? Uint8List.fromList([]),
        convertBloc: convertBloc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AudioPlayer(
      autoplay: true,
      audioAssetPath: Assets.audio.loadingFinished,
      onAudioFinished: () => _finishConvert(context),
      child: BlurryContainer(
        blur: 24,
        child: Center(
          child: SizedBox.square(
            dimension: dimension,
            child: Assets.icons.loadingFinish.image(
              key: const Key('LoadingOverlay_LoadingIndicator'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
