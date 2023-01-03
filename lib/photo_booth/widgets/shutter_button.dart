import 'dart:async';
import 'dart:math' as math;

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

AudioPlayer _getAudioPlayer() => AudioPlayer();

class ShutterButton extends StatefulWidget {
  const ShutterButton({
    super.key,
    required this.onCountdownCompleted,
    ValueGetter<AudioPlayer>? audioPlayer,
  }) : _audioPlayer = audioPlayer ?? _getAudioPlayer;

  final VoidCallback onCountdownCompleted;
  final ValueGetter<AudioPlayer> _audioPlayer;

  static const shutterCountdownDuration = Duration(seconds: 5);
  @override
  State<ShutterButton> createState() => ShutterButtonState();
}

@visibleForTesting
class ShutterButtonState extends State<ShutterButton>
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
      duration: ShutterButton.shutterCountdownDuration,
    )..addStatusListener(_onAnimationStatusChanged);

    final audioSession = await AudioSession.instance;
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    try {
      await audioSession.configure(const AudioSessionConfiguration.speech());
    } catch (_) {}

    // Try to load audio from a source and catch any errors.
    try {
      await audioPlayer.setAsset(Assets.audio.camera);
    } catch (_) {}

    unawaited(controller.reverse(from: 1));
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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (controller.isAnimating) {
          return CountdownTimer(controller: controller);
        }
        return const SizedBox(
          key: emptySizedBox,
        );
      },
    );
  }
}

class CountdownTimer extends StatelessWidget {
  const CountdownTimer({super.key, required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final seconds =
        (ShutterButton.shutterCountdownDuration.inSeconds * controller.value)
            .ceil();
    final theme = Theme.of(context);
    return Container(
      height: 70,
      width: 70,
      margin: const EdgeInsets.only(bottom: 15),
      child: Stack(
        children: [
          Align(
            child: Text(
              '$seconds',
              style: theme.textTheme.displayLarge?.copyWith(
                color: PhotoboothColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: TimerPainter(
                animation: controller,
                controllerValue: controller.value,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  const TimerPainter({
    required this.animation,
    required this.controllerValue,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final double controllerValue;

  @override
  void paint(Canvas canvas, Size size) {
    final progress = (controllerValue / 360) *
        (2 * math.pi * size.width) *
        ShutterButton.shutterCountdownDuration.inSeconds;

    final paint = Paint()
      ..color = PhotoboothColors.white
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = PhotoboothColors.red;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) => false;
}
