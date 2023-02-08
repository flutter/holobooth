import 'package:flutter/material.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class ConvertLoadingAnimation extends StatelessWidget {
  const ConvertLoadingAnimation({
    required this.dimension,
    super.key,
  });

  final double dimension;

  @override
  Widget build(BuildContext context) {
    return AudioPlayer(
      audioAssetPath: Assets.audio.loading,
      autoplay: true,
      loop: true,
      child: BlurryContainer(
        blur: 24,
        child: Center(
          child: SizedBox.square(
            dimension: dimension,
            child: Stack(
              children: [
                SizedBox.square(
                  dimension: dimension,
                  child: Assets.icons.loadingCircle.image(
                    key: const Key('LoadingOverlay_LoadingIndicator'),
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(dimension * 0.015),
                  child: SizedBox.square(
                    dimension: dimension,
                    child: const CircularProgressIndicator(
                      color: HoloBoothColors.convertLoading,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
