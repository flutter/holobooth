import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:holobooth/animoji_intro/view/animoji_intro_page.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class LandingTakePhotoButton extends StatefulWidget {
  const LandingTakePhotoButton({super.key});

  @override
  State<LandingTakePhotoButton> createState() => _LandingTakePhotoButtonState();
}

class _LandingTakePhotoButtonState extends State<LandingTakePhotoButton>
    with AudioPlayerMixin {
  @override
  String get audioAssetPath => Assets.audio.buttonPress;

  @override
  void initState() {
    super.initState();

    loadAudio();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GradientElevatedButton(
      onPressed: () {
        playAudio();
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
