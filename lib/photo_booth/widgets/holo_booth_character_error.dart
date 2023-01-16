import 'package:flutter/material.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class HoloBoothCharacterError extends StatefulWidget {
  const HoloBoothCharacterError({super.key});

  @override
  State<HoloBoothCharacterError> createState() =>
      _HoloBoothCharacterErrorState();
}

class _HoloBoothCharacterErrorState extends State<HoloBoothCharacterError>
    with AudioPlayerMixin {
  @override
  String get audioAssetPath => Assets.audio.faceNotDetected;

  @override
  void initState() {
    super.initState();

    _loadAndPlayAudio();
  }

  Future<void> _loadAndPlayAudio() async {
    await loadAudio();
    await playAudio();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlurryContainer(
      color: HoloBoothColors.blurryContainerColor,
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
    );
  }
}
