import 'package:analytics_repository/analytics_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/camera/bloc/camera_bloc.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth/photo_booth/photo_booth.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class AnimojiNextButton extends StatefulWidget {
  const AnimojiNextButton({super.key});

  @override
  State<AnimojiNextButton> createState() => _AnimojiNextButtonState();
}

class _AnimojiNextButtonState extends State<AnimojiNextButton> {
  final _audioPlayerController = AudioPlayerController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AudioPlayer(
      audioAssetPath: Assets.audio.buttonPress,
      child: GradientElevatedButton(
        onPressed: () {
          _audioPlayerController.playAudio();
          context.read<AnalyticsRepository>().trackEvent(
                const AnalyticsEvent(
                  category: 'button',
                  action: 'click-start-holobooth',
                  label: 'start-holobooth',
                ),
              );
          Navigator.of(context).push(
            PhotoBoothPage.route(context.read<CameraBloc>().state.camera),
          );
        },
        child: Text(l10n.nextButtonText),
      ),
    );
  }
}
