import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/audio_player/audio_player.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class RecordingCountdown extends StatefulWidget {
  const RecordingCountdown({
    super.key,
    required this.onCountdownCompleted,
  });

  final VoidCallback onCountdownCompleted;

  static const shutterCountdownDuration = Duration(seconds: 5);

  @visibleForTesting
  static const emptySizedBox = Key('empty_sizedBox');

  @override
  State<RecordingCountdown> createState() => _RecordingCountdownState();
}

class _RecordingCountdownState extends State<RecordingCountdown>
    with TickerProviderStateMixin, AudioPlayerMixin {
  late final AnimationController controller;

  @override
  String get audioAssetPath => Assets.audio.camera;

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
    controller = AnimationController(
      vsync: this,
      duration: RecordingCountdown.shutterCountdownDuration,
    )..addStatusListener(_onAnimationStatusChanged);

    await loadAudio();

    unawaited(controller.reverse(from: 1));
  }

  @override
  void dispose() {
    controller
      ..removeStatusListener(_onAnimationStatusChanged)
      ..dispose();

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
