import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class SocialMediaShareClarificationNote extends StatelessWidget {
  const SocialMediaShareClarificationNote({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final small =
        MediaQuery.of(context).size.width <= HoloboothBreakpoints.small;
    return SelectableText.rich(
      TextSpan(
        style: theme.textTheme.bodySmall?.copyWith(
          color: HoloBoothColors.lightGrey,
          fontWeight: HoloboothFontWeight.regular,
        ),
        children: <TextSpan>[
          TextSpan(
            text: l10n.sharePageSocialMediaShareClarification1,
          ),
          TextSpan(
            text: l10n.sharePageSocialMediaShareClarification2,
            recognizer: TapGestureRecognizer()..onTap = launchPhotoboothEmail,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
      textAlign: small ? TextAlign.center : TextAlign.start,
    );
  }
}
