import 'package:flutter/material.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class ConvertMessage extends StatelessWidget {
  const ConvertMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        GradientText(
          text: l10n.convertMessage,
          style: textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.convertInfo,
          style: textTheme.bodyMedium?.copyWith(
            color: HoloBoothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
