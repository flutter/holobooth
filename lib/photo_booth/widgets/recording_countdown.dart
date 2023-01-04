import 'dart:async';
import 'dart:math' as math;

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

AudioPlayer _getAudioPlayer() => AudioPlayer();

class RecordingCountdown extends StatefulWidget {
  const RecordingCountdown({
    super.key,
    required this.onCountdownCompleted,
    ValueGetter<AudioPlayer>? audioPlayer,
  }) : _audioPlayer = audioPlayer ?? _getAudioPlayer;

  final VoidCallback onCountdownCompleted;
  final ValueGetter<AudioPlayer> _audioPlayer;

  static const shutterCountdownDuration = Duration(seconds: 3);

  @visibleForTesting
  static const emptySizedBox = Key('empty_sizedBox');

  @override
  State<RecordingCountdown> createState() => _RecordingCountdownState();
}

class _RecordingCountdownState extends State<RecordingCountdown>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  late final AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
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
      duration: RecordingCountdown.shutterCountdownDuration,
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
          key: RecordingCountdown.emptySizedBox,
        );
      },
    );
  }
}

@visibleForTesting
class CountdownTimer extends StatelessWidget {
  const CountdownTimer({super.key, required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      margin: const EdgeInsets.only(bottom: 15),
      child: Stack(
        children: [
          Align(
            child: ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: <Color>[
                    HoloBoothColors.gradientSecondaryThreeStart,
                    HoloBoothColors.gradientSecondaryThreeStop,
                  ],
                ).createShader(Offset.zero & bounds.size);
              },
              child: const Icon(Icons.videocam, color: Colors.white, size: 40),
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

@visibleForTesting
class TimerPainter extends CustomPainter {
  const TimerPainter({
    required this.animation,
    required this.controllerValue,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final double controllerValue;

  @override
  void paint(Canvas canvas, Size size) {
    final progress =
        Tween<double>(begin: 0, end: math.pi * 2).evaluate(animation);
    final rect = Rect.fromCircle(center: Offset.zero, radius: size.width);
    final paint = Paint()
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..shader = const LinearGradient(
        colors: [
          HoloBoothColors.gradientSecondaryFourStart,
          HoloBoothColors.gradientSecondaryFourStop,
        ],
      ).createShader(rect);
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) => false;
}
