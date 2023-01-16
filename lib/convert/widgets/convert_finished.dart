import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/audio_player/audio_player.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ConvertFinished extends StatefulWidget {
  const ConvertFinished({
    super.key,
    required this.dimension,
  });

  final double dimension;

  @override
  State<ConvertFinished> createState() => _ConvertFinishedState();
}

class _ConvertFinishedState extends State<ConvertFinished>
    with AudioPlayerMixin {
  @override
  String get audioAssetPath => Assets.audio.loadingFinished;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Try to load audio from a source and catch any errors.
    try {
      await loadAudio();
      await playAudio();
    } catch (_) {
    } finally {
      _finishConvert();
    }
  }

  void _finishConvert() {
    final state = context.read<ConvertBloc>().state;
    Navigator.of(context).push(
      SharePage.route(
        videoPath: state.videoPath,
        firstFrame: state.firstFrameProcessed ?? Uint8List.fromList([]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      blur: 24,
      child: Center(
        child: SizedBox.square(
          dimension: widget.dimension,
          child: Assets.icons.loadingFinish.image(
            key: const Key('LoadingOverlay_LoadingIndicator'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
