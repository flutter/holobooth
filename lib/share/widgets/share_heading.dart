import 'package:flutter/material.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class ShareHeading extends StatelessWidget {
  const ShareHeading({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final isSmallScreen =
        MediaQuery.of(context).size.width <= HoloboothBreakpoints.small;
    return GradientText(
      text: l10n.sharePageHeading,
      textAlign: isSmallScreen ? TextAlign.center : TextAlign.left,
      style: textTheme.headlineMedium,
    );
  }
}
