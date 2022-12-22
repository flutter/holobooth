import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:just_audio/just_audio.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

AudioPlayer _getAudioPlayer() => AudioPlayer();

class PreparingLayer extends StatefulWidget {
  const PreparingLayer({
    super.key,
    required this.onCountdownCompleted,
    ValueGetter<AudioPlayer>? audioPlayer,
  }) : _audioPlayer = audioPlayer ?? _getAudioPlayer;

  final VoidCallback onCountdownCompleted;
  final ValueGetter<AudioPlayer> _audioPlayer;

  static const countdownDuration = Duration(seconds: 4);

  @override
  State<PreparingLayer> createState() => PreparingLayerState();
}

@visibleForTesting
class PreparingLayerState extends State<PreparingLayer>
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
      duration: PreparingLayer.countdownDuration,
    )..addStatusListener(_onAnimationStatusChanged);

    try {
      final audioSession = await AudioSession.instance;
      await audioSession.configure(const AudioSessionConfiguration.speech());
      await audioPlayer.setAsset(Assets.audio.counting);
    } catch (_) {}

    await controller.forward();
  }

  Future<void> _onShutterPressed() async {
    unawaited(audioPlayer.play());
    // widget.onCountdownStarted();
    unawaited(controller.reverse(from: 1));
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: IntTween(begin: 3, end: 0),
      duration: const Duration(seconds: 3),
      onEnd: () {
        widget.onCountdownCompleted();
      },
      builder: (context, value, child) {
        audioPlayer.play();
        return PreparingCountdownTimer2(
          seconds: value,
          audioPlayer: audioPlayer,
        );
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      audioPlayer.stop();
    }
  }
}

class PreparingCountdownTimer2 extends StatelessWidget {
  const PreparingCountdownTimer2({
    super.key,
    required this.seconds,
    required this.audioPlayer,
  });

  final int seconds;
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Container(
            color: const Color(0xFF0D162C).withAlpha(75),
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
              style: PhotoboothTextStyle.displayLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
