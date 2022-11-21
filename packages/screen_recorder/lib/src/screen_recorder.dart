import 'package:flutter/material.dart';
import 'package:screen_recorder/screen_recorder.dart';

/// TODO(arturplaczek): Add tests at final version.

/// {@template screen_recorder}
/// Widget that allows to record the given [child].
/// {@endtemplate}
class ScreenRecorder extends StatelessWidget {
  /// {@macro screen_recorder}
  ScreenRecorder({
    super.key,
    required this.child,
    required this.controller,
    required this.width,
    required this.height,
    this.background = Colors.white,
  }) : assert(
          background.alpha == 255,
          'background color is not allowed to be transparent',
        );

  /// The child which should be recorded.
  final Widget child;

  /// This controller starts and stops the recording.
  final ScreenRecorderController controller;

  /// Width of the recording.
  /// This should not change during recording as it could lead to
  /// undefined behavior.
  final double width;

  /// Height of the recording
  /// This should not change during recording as it could lead to
  /// undefined behavior.
  final double height;

  /// The background color of the recording.
  /// Transparency is currently not supported.
  final Color background;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: controller.containerKey,
      child: Container(
        width: width,
        height: height,
        color: background,
        child: child,
      ),
    );
  }
}
