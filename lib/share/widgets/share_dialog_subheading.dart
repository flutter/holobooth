import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class ShareDialogSubheading extends StatelessWidget {
  const ShareDialogSubheading({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return SelectableText(
      l10n.shareDialogSubheading,
      style: theme.textTheme.displayMedium?.copyWith(color: Colors.white),
    );
  }
}
