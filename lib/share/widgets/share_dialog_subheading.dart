import 'package:flutter/material.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class ShareDialogSubheading extends StatelessWidget {
  const ShareDialogSubheading({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final small =
        MediaQuery.of(context).size.width <= HoloboothBreakpoints.small;
    return SelectableText.rich(
      TextSpan(
        style:
            theme.textTheme.bodyMedium?.copyWith(color: HoloBoothColors.white),
        children: <TextSpan>[
          TextSpan(
            text: l10n.shareDialogSubheading1,
          ),
          TextSpan(
            text: l10n.shareDialogSubheading2,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: HoloBoothColors.lighterPurple),
          ),
          TextSpan(
            text: l10n.shareDialogSubheading3,
          ),
        ],
      ),
      textAlign: small ? TextAlign.center : TextAlign.start,
    );
  }
}
