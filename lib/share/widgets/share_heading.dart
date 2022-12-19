import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareHeading extends StatelessWidget {
  const ShareHeading({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final isSmallScreen =
        MediaQuery.of(context).size.width <= PhotoboothBreakpoints.small;
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [
            // TODO(willhlas): use theme colors once it's ready.
            Color(0xFFEFBDCF),
            Color(0xFF9E81EF),
          ],
        ).createShader(Offset.zero & bounds.size);
      },
      child: SelectableText(
        l10n.sharePageHeading,
        style: textTheme.displayLarge?.copyWith(
          color: PhotoboothColors.white,
        ),
        textAlign: isSmallScreen ? TextAlign.center : TextAlign.left,
      ),
    );
  }
}
