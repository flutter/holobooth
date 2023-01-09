import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class HoloBoothCharacterError extends StatelessWidget {
  const HoloBoothCharacterError({super.key});

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
