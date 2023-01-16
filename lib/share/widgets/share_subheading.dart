import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class ShareSubheading extends StatelessWidget {
  const ShareSubheading({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isSmallScreen =
        MediaQuery.of(context).size.width <= PhotoboothBreakpoints.small;
    return SelectableText.rich(
      TextSpan(
        text: l10n.sharePageLearnMoreAboutTextPart1,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: PhotoboothFontWeight.regular,
          color: HoloBoothColors.white,
        ),
        children: <TextSpan>[
          TextSpan(
            text: l10n.sharePageLearnMoreAboutTextLink1,
            recognizer: TapGestureRecognizer()
              ..onTap = () => openLink(howItsMadeLink),
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
          TextSpan(
            text: l10n.sharePageLearnMoreAboutTextPart2,
          ),
          TextSpan(
            text: l10n.sharePageLearnMoreAboutTextLink2,
            recognizer: TapGestureRecognizer()
              ..onTap = () => openLink(flutterForwardLink),
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
          TextSpan(
            text: l10n.sharePageLearnMoreAboutTextPart3,
          ),
          TextSpan(
            text: l10n.sharePageLearnMoreAboutTextLink3,
            recognizer: TapGestureRecognizer()
              ..onTap = () => openLink(repositoryLink),
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
          TextSpan(
            text: l10n.sharePageLearnMoreAboutTextPart4,
          ),
        ],
      ),
      textAlign: isSmallScreen ? TextAlign.center : TextAlign.left,
    );
  }
}
