import 'package:flutter/material.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class HoloBoothCharacterError extends StatelessWidget {
  const HoloBoothCharacterError({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AudioPlayer(
      audioAssetPath: Assets.audio.faceNotDetected,
      autoplay: true,
      child: BlurryContainer(
        color: HoloBoothColors.blurrySurface,
        blur: 7.5,
        borderRadius: BorderRadius.circular(38),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error,
              color: HoloBoothColors.red,
            ),
            const SizedBox(width: 12),
            Text(
              l10n.faceNotDetected,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: HoloBoothColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
