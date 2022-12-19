import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareDialogSubheading extends StatelessWidget {
  const ShareDialogSubheading({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final small =
        MediaQuery.of(context).size.width <= PhotoboothBreakpoints.small;
    return SelectableText(
      l10n.shareDialogSubheading,
      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
      textAlign: small ? TextAlign.center : TextAlign.start,
    );
  }
}
