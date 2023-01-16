import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/audio_player/audio_player.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ConvertLoadingAnimation extends StatefulWidget {
  const ConvertLoadingAnimation({
    super.key,
    required this.dimension,
  });

  final double dimension;

  @override
  State<ConvertLoadingAnimation> createState() =>
      _ConvertLoadingAnimationState();
}

class _ConvertLoadingAnimationState extends State<ConvertLoadingAnimation>
    with AudioPlayerMixin {
  @override
  String get audioAssetPath => Assets.audio.loading;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Try to load audio from a source and catch any errors.
    try {
      await loadAudio();
      await playAudio(loop: true);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      blur: 24,
      child: Center(
        child: SizedBox.square(
          dimension: widget.dimension,
          child: Stack(
            children: [
              SizedBox.square(
                dimension: widget.dimension,
                child: Assets.icons.loadingCircle.image(
                  key: const Key('LoadingOverlay_LoadingIndicator'),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(widget.dimension * 0.015),
                child: SizedBox.square(
                  dimension: widget.dimension,
                  child: const CircularProgressIndicator(
                    color: HoloBoothColors.convertLoading,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
