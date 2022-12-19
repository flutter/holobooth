import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/rive/rive.dart';
import 'package:rive/rive.dart';

class BaseCharacterAnimation extends StatefulWidget {
  const BaseCharacterAnimation({
    super.key,
    required this.avatar,
    required this.hat,
    required this.glasses,
    required this.clothes,
    required this.handheldlLeft,
    required this.assetGenImage,
  });

  final Avatar avatar;
  final Hats hat;
  final Glasses glasses;
  final Clothes clothes;
  final HandheldlLeft handheldlLeft;
  final RiveGenImage assetGenImage;

  @override
  State<BaseCharacterAnimation> createState() => BaseCharacterAnimationState();
}

class BaseCharacterAnimationState<T extends BaseCharacterAnimation>
    extends State<T> with TickerProviderStateMixin {
  /// The amount of head movement required to trigger a rotation animation.
  ///
  /// The smaller the value the more sensitive the animation will be.
  static const _rotationToleration = 3;

  /// The amount of eye movement required to trigger an eye animation.
  ///
  /// The smaller the value the more sensitive the animation will be. This
  /// tolerance applies to both the left and right eye.
  static const _eyeDistanceToleration = 10;

  /// The minimum number of samples taken before the eye animation will be
  /// enabled.
  ///
  /// This is due to the fact that the eye geometry requires some calibration
  /// before it can be used. This applies to both the left and right eye.
  static const _eyePopulationMin = 100;

  /// The amount of eye movement required to consider the eye as fully closed.
  ///
  /// This applies to both the left and right eye.
  static const _blinkToleration = 20;

  @visibleForTesting
  CharacterStateMachineController? dashController;

  late final AnimationController _rotationAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 50),
  );
  final Tween<Offset> _rotationTween =
      Tween(begin: Offset.zero, end: Offset.zero);

  late final AnimationController _leftEyeAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 70),
  );
  final Tween<double> _leftEyeTween = Tween(begin: 0, end: 0);

  late final AnimationController _rightEyeAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 70),
  );
  final Tween<double> _rightEyeTween = Tween(begin: 0, end: 0);

  void onRiveInit(Artboard artboard) {
    dashController = CharacterStateMachineController(artboard);
    artboard.addController(dashController!);
    _rotationAnimationController.addListener(_controlDashPosition);
    _leftEyeAnimationController.addListener(_controlLeftEye);
    _rightEyeAnimationController.addListener(_controlRightEye);
  }

  void _controlDashPosition() {
    final dashController = this.dashController;
    if (dashController != null) {
      final offset = _rotationTween.evaluate(_rotationAnimationController);
      dashController.x.change(offset.dx);
      dashController.y.change(offset.dy);
    }
  }

  void _controlLeftEye() {
    final dashController = this.dashController;
    if (dashController == null) return;

    final distance = _leftEyeTween.evaluate(_leftEyeAnimationController);
    dashController.leftEyeIsClosed.change(distance);
  }

  void _controlRightEye() {
    final dashController = this.dashController;
    if (dashController == null) return;

    final distance = _rightEyeTween.evaluate(_rightEyeAnimationController);
    dashController.rightEyeIsClosed.change(distance);
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    final dashController = this.dashController;
    if (dashController != null) {
      final previousOffset =
          Offset(dashController.x.value, dashController.y.value);
      // Direction has range of values [-1, 1], and the
      // animation controller [-100, 100] so we multiply
      // by 100 to correlate the values
      final newOffset = Offset(
        widget.avatar.direction.x * 100,
        widget.avatar.direction.y * 100,
      );
      if ((newOffset - previousOffset).distance > _rotationToleration) {
        _rotationTween
          ..begin = previousOffset
          ..end = newOffset;
        _rotationAnimationController.forward(from: 0);
      }

      if (oldWidget.avatar.mouthDistance != widget.avatar.mouthDistance) {
        dashController.mouthDistance.change(
          widget.avatar.mouthDistance * 100,
        );
      }

      final previousLeftEyeValue = dashController.leftEyeIsClosed.value;
      final leftEyeGeometry = widget.avatar.leftEyeGeometry;
      late final double newLeftEyeValue;
      if (leftEyeGeometry.generation > _eyePopulationMin &&
          leftEyeGeometry.minRatio != null &&
          leftEyeGeometry.meanRatio != null &&
          leftEyeGeometry.distance != null &&
          leftEyeGeometry.meanRatio! > leftEyeGeometry.minRatio!) {
        final accurateNewLeftEyeValue = 100 -
            leftEyeGeometry.distance!.normalize(
              fromMin: leftEyeGeometry.minRatio!,
              fromMax: leftEyeGeometry.meanRatio!,
              toMin: 0,
              toMax: 100,
            );

        if (accurateNewLeftEyeValue > _blinkToleration) {
          newLeftEyeValue = 100;
        } else {
          newLeftEyeValue = accurateNewLeftEyeValue;
        }
      } else {
        newLeftEyeValue = 0;
      }
      if ((newLeftEyeValue - previousLeftEyeValue).abs() >
          _eyeDistanceToleration) {
        _leftEyeTween
          ..begin = previousLeftEyeValue
          ..end = newLeftEyeValue;
        _leftEyeAnimationController.forward(from: 0);
      }

      final previousRightEyeValue = dashController.rightEyeIsClosed.value;
      final rightEyeGeometry = widget.avatar.rightEyeGeometry;
      late final double newRightEyeValue;
      if (rightEyeGeometry.generation > _eyePopulationMin &&
          rightEyeGeometry.minRatio != null &&
          rightEyeGeometry.meanRatio != null &&
          leftEyeGeometry.distance != null &&
          rightEyeGeometry.meanRatio! > rightEyeGeometry.minRatio!) {
        final accurateNewLeftEyeValue = 100 -
            rightEyeGeometry.distance!.normalize(
              fromMin: rightEyeGeometry.minRatio!,
              fromMax: rightEyeGeometry.meanRatio!,
              toMin: 0,
              toMax: 100,
            );
        if (accurateNewLeftEyeValue > _blinkToleration) {
          newRightEyeValue = 100;
        } else {
          newRightEyeValue = accurateNewLeftEyeValue;
        }
      } else {
        newRightEyeValue = 0;
      }
      if ((newRightEyeValue - previousRightEyeValue).abs() >
          _eyeDistanceToleration) {
        _rightEyeTween
          ..begin = previousRightEyeValue
          ..end = newRightEyeValue;
        _rightEyeAnimationController.forward(from: 0);
      }

      if (oldWidget.hat != widget.hat) {
        dashController.hats.change(
          widget.hat.index.toDouble(),
        );
      }
      if (oldWidget.glasses != widget.glasses) {
        dashController.glasses.change(
          widget.glasses.riveIndex,
        );
      }
      if (oldWidget.clothes != widget.clothes) {
        dashController.clothes.change(
          widget.clothes.index.toDouble(),
        );
      }
      if (oldWidget.handheldlLeft != widget.handheldlLeft) {
        dashController.handheldlLeft.change(
          widget.handheldlLeft.index.toDouble(),
        );
      }
    }
  }

  @override
  void dispose() {
    dashController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.assetGenImage.rive(
      onInit: onRiveInit,
      fit: BoxFit.cover,
    );
  }
}

extension on num {
  double normalize({
    required num fromMin,
    required num fromMax,
    required num toMin,
    required num toMax,
  }) {
    return (toMax - toMin) * ((this - fromMin) / (fromMax - fromMin)) + toMin;
  }
}
