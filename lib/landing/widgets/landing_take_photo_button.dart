import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/backround_selection/view/background_selection.dart';
import 'package:io_photobooth/l10n/l10n.dart';

class LandingTakePhotoButton extends StatelessWidget {
  const LandingTakePhotoButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () {
        trackEvent(
          category: 'button',
          action: 'click-start-photobooth',
          label: 'start-photobooth',
        );
        Navigator.of(context).push<void>(BackgroundSelectionPage.route());
      },
      child: Text(l10n.landingPageTakePhotoButtonText),
    );
  }
}
