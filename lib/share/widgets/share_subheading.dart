import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareSubheading extends StatelessWidget {
  const ShareSubheading({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SelectableText.rich(
      TextSpan(
        text: l10n.sharePageLearnMoreAboutTextPart1,
        style: theme.textTheme.headline3?.copyWith(
          fontWeight: PhotoboothFontWeight.regular,
          color: PhotoboothColors.white,
        ),
        children: <TextSpan>[
          TextSpan(
            text: l10n.footerMadeWithFlutterLinkText,
            recognizer: TapGestureRecognizer()
              ..onTap = () => openLink(flutterDevExternalLink),
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
          TextSpan(
            text: l10n.sharePageLearnMoreAboutTextPart2,
          ),
          TextSpan(
            text: l10n.footerMadeWithFirebaseLinkText,
            recognizer: TapGestureRecognizer()
              ..onTap = () => openLink(firebaseExternalLink),
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
          TextSpan(
            text: l10n.sharePageLearnMoreAboutTextPart3,
          ),
          TextSpan(
            text: l10n.sharePageLearnMoreAboutTextPart4,
            recognizer: TapGestureRecognizer()
              ..onTap = () => openLink(openSourceLink),
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
