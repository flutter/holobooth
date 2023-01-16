import 'dart:async';

import 'package:flutter/material.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class GetReadyLayer extends StatefulWidget {
  const GetReadyLayer({
    super.key,
    required this.onCountdownCompleted,
  });

  final VoidCallback onCountdownCompleted;

  static const countdownDuration = Duration(seconds: 3);

  @visibleForTesting
  static const emptySizedBox = Key('empty_sizedBox');

  @override
  State<GetReadyLayer> createState() => _GetReadyLayerState();
}

class _GetReadyLayerState extends State<GetReadyLayer>
    with TickerProviderStateMixin, AudioPlayerMixin {
  late final AnimationController controller;

  @override
  String get audioAssetPath => Assets.audio.counting3Seconds;

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
      duration: GetReadyLayer.countdownDuration,
    )..addStatusListener(_onAnimationStatusChanged);

    try {
      await loadAudio();
      unawaited(playAudio());
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
        return const SizedBox(key: GetReadyLayer.emptySizedBox);
      },
    );
  }

  @override
  void dispose() {
    controller
      ..removeStatusListener(_onAnimationStatusChanged)
      ..dispose();

    super.dispose();
  }
}

@visibleForTesting
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
    final isSmall =
        MediaQuery.of(context).size.width <= HoloboothBreakpoints.small;
    return Stack(
      fit: StackFit.expand,
      children: [
        const Positioned.fill(
          child: ColoredBox(color: HoloBoothColors.blurrySurface),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO(oscar): add border or images to text
            Align(
              child: GradientText(
                text: '$seconds',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: isSmall ? 280 : 400,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            GradientText(
              text: l10n.getReady,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
