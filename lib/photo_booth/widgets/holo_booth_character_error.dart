import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class HoloBoothCharacterError extends StatelessWidget {
  const HoloBoothCharacterError({super.key});

  @override
  Widget build(BuildContext context) {
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
            Icons.priority_high,
            color: PhotoboothColors.white,
          ),
          const SizedBox(width: 12),
          Text(
            'Face not detected',
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
