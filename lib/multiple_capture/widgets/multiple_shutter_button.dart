import 'package:flutter/material.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';

class MultipleShutterButton extends StatefulWidget {
  const MultipleShutterButton({
    super.key,
    required this.onPartialShutterCompleted,
  });

  final Future<void> Function() onPartialShutterCompleted;

  @override
  State<MultipleShutterButton> createState() => _MultipleShutterButtonState();
}

class _MultipleShutterButtonState extends State<MultipleShutterButton>
    with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: _shutterCountdownDuration,
  );
  static const _shutterCountdownDuration = Duration(seconds: 3);

  var _count = 0;

  @override
  void initState() {
    super.initState();
    _animationController.addStatusListener(_onAnimationStatusChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _runAnimation() {
    _animationController.reverse(from: 1);
  }

  Future<void> _onAnimationStatusChanged(AnimationStatus status) async {
    if (status == AnimationStatus.dismissed && _count < maxPhotos) {
      setState(() => _count++);
      await widget.onPartialShutterCompleted();
      _runAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        if (_animationController.isAnimating) {
          return CountdownTimer(controller: _animationController);
        } else if (_count == 0) {
          return CameraButton(onPressed: _runAnimation);
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
