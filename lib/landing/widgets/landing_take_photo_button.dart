import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/animoji_intro/view/animoji_intro_page.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class LandingTakePhotoButton extends StatelessWidget {
  const LandingTakePhotoButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GradientElevatedButton(
      onPressed: () {
        trackEvent(
          category: 'button',
          action: 'click-start-photobooth',
          label: 'start-photobooth',
        );
        Navigator.of(context).push<void>(AnimojiIntroPage.route());
      },
      child: Text(l10n.landingPageTakePhotoButtonText),
    );
  }
}
