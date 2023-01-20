import 'package:analytics_repository/analytics_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _LandingTakePhotoButtonState extends State<LandingTakePhotoButton> {
  final _audioPlayerController = AudioPlayerController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AudioPlayer(
      audioAssetPath: Assets.audio.buttonPress,
      controller: _audioPlayerController,
      child: GradientElevatedButton(
        onPressed: () {
          _audioPlayerController.playAudio();
          context.read<AnalyticsRepository>().trackEvent(
                const AnalyticsEvent(
                  category: 'button',
                  action: 'click-get-started',
                  label: 'get-started',
                ),
              );
          Navigator.of(context).push<void>(AnimojiIntroPage.route());
        },
        child: Text(l10n.landingPageTakePhotoButtonText),
      ),
    );
  }
}
