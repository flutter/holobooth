import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareDialogHeading extends StatelessWidget {
  const ShareDialogHeading({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final small =
        MediaQuery.of(context).size.width <= PhotoboothBreakpoints.small;

    return GradientText(
      text: l10n.shareDialogHeading,
      style:
          small ? theme.textTheme.displayLarge : theme.textTheme.displaySmall,
      textAlign: small ? TextAlign.center : TextAlign.start,
    );
  }
}
