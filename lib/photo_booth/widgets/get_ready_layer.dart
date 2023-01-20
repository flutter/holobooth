import 'dart:async';

import 'package:flutter/material.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class GetReadyLayer extends StatefulWidget {
  const GetReadyLayer({
    super.key,
    required this.onCountdownCompleted,
  });

  final VoidCallback onCountdownCompleted;

  static const countdownDuration = Duration(seconds: 1);

  @override
  State<GetReadyLayer> createState() => _GetReadyLayerState();
}

class _GetReadyLayerState extends State<GetReadyLayer>
    with TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: GetReadyLayer.countdownDuration,
    )..addStatusListener(_onAnimationStatusChanged);

    controller.reverse(from: 1);
  }

  Future<void> _onAnimationStatusChanged(AnimationStatus status) async {
    if (status == AnimationStatus.dismissed) {
      widget.onCountdownCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => GetReadyCountdown(controller: controller),
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
