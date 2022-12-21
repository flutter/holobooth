import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ConvertMessage extends StatelessWidget {
  const ConvertMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        GradientText(
          text: l10n.convertMessage,
          style: PhotoboothTextStyle.displayMedium,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.convertInfo,
          style: PhotoboothTextStyle.bodyMedium.copyWith(
            color: PhotoboothColors.white,
          ),
        ),
      ],
    );
  }
}
