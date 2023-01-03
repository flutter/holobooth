import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:just_audio/just_audio.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

AudioPlayer _getAudioPlayer() => AudioPlayer();

class GetReadyLayer extends StatefulWidget {
  const GetReadyLayer({
    super.key,
    required this.onCountdownCompleted,
    ValueGetter<AudioPlayer>? audioPlayer,
  }) : _audioPlayer = audioPlayer ?? _getAudioPlayer;

  final VoidCallback onCountdownCompleted;
  final ValueGetter<AudioPlayer> _audioPlayer;

  static const countdownDuration = Duration(seconds: 3);

  @override
  State<GetReadyLayer> createState() => GetReadyLayerState();
}

@visibleForTesting
class GetReadyLayerState extends State<GetReadyLayer>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController controller;
  late final AudioPlayer audioPlayer;

  @visibleForTesting
  static const emptySizedBox = Key('empty_sizedBox');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  Future<void> _onAnimationStatusChanged(AnimationStatus status) async {
    if (status == AnimationStatus.dismissed) {
      widget.onCountdownCompleted();
    }
  }

  Future<void> _init() async {
    audioPlayer = widget._audioPlayer();
    controller = AnimationController(
      vsync: this,
      duration: GetReadyLayer.countdownDuration,
    )..addStatusListener(_onAnimationStatusChanged);

    try {
      final audioSession = await AudioSession.instance;
      await audioSession.configure(const AudioSessionConfiguration.speech());
      await audioPlayer.setAsset(Assets.audio.counting);
      unawaited(audioPlayer.play());
    } catch (_) {}

    await controller.reverse(from: 1);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (controller.isAnimating) {
          return GetReadyCountdown(controller: controller);
        }
        return const SizedBox(key: emptySizedBox);
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    controller
      ..removeStatusListener(_onAnimationStatusChanged)
      ..dispose();
    audioPlayer.dispose();
    super.dispose();
  }
}

class GetReadyCountdown extends StatelessWidget {
  const GetReadyCountdown({
    super.key,
    required this.controller,
  });

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final seconds =
        (GetReadyLayer.countdownDuration.inSeconds * controller.value).ceil();
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Container(
            color: const Color.fromRGBO(19, 22, 44, 0.75),
          ),
        ),
        Column(
          children: [
            GradientText(
              text: '$seconds',
              style: PhotoboothTextStyle.displayMedium.copyWith(
                fontSize: 400,
              ),
              textAlign: TextAlign.center,
            ),
            GradientText(
              text: l10n.getReady,
              style: PhotoboothTextStyle.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
