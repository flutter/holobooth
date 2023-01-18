import 'package:analytics_repository/analytics_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth/photo_booth/photo_booth.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class AnimojiNextButton extends StatefulWidget {
  const AnimojiNextButton({super.key});

  @override
  State<AnimojiNextButton> createState() => _AnimojiNextButtonState();
}

class _AnimojiNextButtonState extends State<AnimojiNextButton>
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
        context.read<AnalyticsRepository>().trackEvent(
              const AnalyticsEvent(
                category: 'button',
                action: 'click-start-holobooth',
                label: 'start-holobooth',
              ),
            );
        Navigator.of(context).push(PhotoBoothPage.route());
      },
      child: Text(l10n.nextButtonText),
    );
  }
}
