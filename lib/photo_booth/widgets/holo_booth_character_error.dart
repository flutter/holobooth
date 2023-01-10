import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/audio_player/audio_player.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

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
      // TODO(OSCAR): This color is not in the palette.
      color: const Color.fromRGBO(19, 22, 44, 0.75),
      blur: 7.5,
      borderRadius: BorderRadius.circular(38),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error,
            color: PhotoboothColors.red,
          ),
          const SizedBox(width: 12),
          Text(
            l10n.faceNotDetected,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: PhotoboothColors.white),
          ),
        ],
      ),
    );
  }
}
