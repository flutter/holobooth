import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class ShareDialogHeading extends StatelessWidget {
  const ShareDialogHeading({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return SelectableText(
      l10n.shareDialogHeading,
      style: theme.textTheme.displayLarge?.copyWith(color: Colors.white),
    );
  }
}
