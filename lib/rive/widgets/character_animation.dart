import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/rive/rive.dart';
import 'package:rive/rive.dart';

class DashCharacterAnimation extends CharacterAnimation {
  DashCharacterAnimation({
    super.key,
    required super.avatar,
    required super.hat,
    required super.glasses,
    required super.clothes,
    required super.handheldlLeft,
  }) : super(
          assetGenImage: Assets.animations.dash,
          riveImageSize: const Size(2400, 2100),
        );
}

class SparkyCharacterAnimation extends CharacterAnimation {
  SparkyCharacterAnimation({
    super.key,
    required super.avatar,
    required super.hat,
    required super.glasses,
    required super.clothes,
    required super.handheldlLeft,
  }) : super(
          assetGenImage: Assets.animations.sparky,
          riveImageSize: const Size(2500, 2100),
        );
}

@visibleForTesting
class CharacterAnimation extends StatefulWidget {
  const CharacterAnimation({
    super.key,
    required this.avatar,
    required this.hat,
    required this.glasses,
    required this.clothes,
    required this.handheldlLeft,
    required this.assetGenImage,
    required this.riveImageSize,
  });

  final Avatar avatar;
  final Hats hat;
  final Glasses glasses;
  final Clothes clothes;
  final HandheldlLeft handheldlLeft;
  final RiveGenImage assetGenImage;
  final Size riveImageSize;

  @override
  State<CharacterAnimation> createState() => CharacterAnimationState();
}

class CharacterAnimationState<T extends CharacterAnimation> extends State<T>
    with TickerProviderStateMixin {
  /// The amount of head movement required to trigger a rotation animation.
  ///
  /// The smaller the value the more sensitive the animation will be.
  static const _rotationToleration = 3;

  /// The amount of eye movement required to trigger an eye animation.
  ///
  /// The smaller the value the more sensitive the animation will be. This
  /// tolerance applies to both the left and right eye.
  static const _eyeDistanceToleration = 10;

  /// The minimum number of samples taken before the eye animation is
  /// enabled.
  ///
  /// This is due to the fact that the eye geometry requires some calibration
  /// before it can be used. This applies to both the left and right eye.
  static const _eyePopulationMin = 100;

  /// The amount of eye movement required to consider the eye as fully closed.
  ///
  /// The higher the value the more the eye will be allowed to be closed before
  /// it is considered to be a full closure. This applies to both the left and
  /// right eye.
  static const _eyeClosureToleration = 50;

  /// The amount of movement towards or from the camera required to trigger a
  /// scale animation.
  ///
  /// The smaller the value the more sensitive the animation will be.
  static const _scaleToleration = .1;

  /// The amount we scale the rotation movement by.
  ///
  /// The larger the value the less head movement is required to trigger a
  /// rotation animation. In other words, the larger the value the easier it is
  /// to reach the limits of the rotation animation.
  @visibleForTesting
  static const rotationScale = 2;

  /// The amount of mouth movement required to trigger a mouth animation.
  ///
  /// The smaller the value the more sensitive the animation will be.
  @visibleForTesting
  static const mouthToleration = 3;

  /// The amount we scale the mouth movement by.
  ///
  /// The larger the value the less mouth movement is required to trigger a
  /// mouth animation. In other words, the larger the value the easier it is to
  /// reach the limits of the mouth animation.
  @visibleForTesting
  static const mouthScale = 5.0;

  @visibleForTesting
  CharacterStateMachineController? characterController;

  late final AnimationController _rotationAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 50),
  );
  final Tween<Vector3> _rotationTween =
      Tween(begin: Vector3.zero, end: Vector3.zero);

  late final AnimationController _leftEyeAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 60),
  );
  final Tween<double> _leftEyeTween = Tween(begin: 0, end: 0);

  late final AnimationController _rightEyeAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 60),
  );
  final Tween<double> _rightEyeTween = Tween(begin: 0, end: 0);

  late final AnimationController _mouthAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 50),
  );
  final Tween<double> _mouthTween = Tween(begin: 0, end: 0);

  late double _scale;

  void onRiveInit(Artboard artboard) {
    characterController = CharacterStateMachineController(artboard);
    artboard.addController(characterController!);
    _rotationAnimationController.addListener(_controlDashRotation);
    _leftEyeAnimationController.addListener(_controlLeftEye);
    _rightEyeAnimationController.addListener(_controlRightEye);
    _mouthAnimationController.addListener(_controlMouth);
  }

  void _controlDashRotation() {
    final characterController = this.characterController;
    if (characterController != null) {
      final vector = _rotationTween.evaluate(_rotationAnimationController);
      characterController.x.change(vector.x.clamp(-100, 100));
      characterController.y.change(vector.y.clamp(-100, 100));
      characterController.z.change(vector.z.clamp(-100, 100));
    }
  }

  void _controlLeftEye() {
    final characterController = this.characterController;
    if (characterController == null) return;

    final distance = _leftEyeTween.evaluate(_leftEyeAnimationController);
    characterController.leftEyeIsClosed.change(distance);
  }

  void _controlRightEye() {
    final characterController = this.characterController;
    if (characterController == null) return;

    final distance = _rightEyeTween.evaluate(_rightEyeAnimationController);
    characterController.rightEyeIsClosed.change(distance);
  }

  void _controlMouth() {
    final characterController = this.characterController;
    if (characterController == null) return;

    final distance = _mouthTween.evaluate(_mouthAnimationController);
    characterController.mouthDistance.change(distance.clamp(0, 100));
  }

  @override
  void initState() {
    super.initState();
    _scale = widget.avatar.distance.normalize(
      fromMax: 1,
      toMin: 0.8,
      toMax: 5,
    );
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    final characterController = this.characterController;
    if (characterController != null) {
      final previousRotationVector = Vector3(
        characterController.x.value,
        characterController.y.value,
        characterController.z.value,
      );
      // Direction has range of values [-1, 1], and the
      // animation controller [-100, 100] so we multiply
      // by 100 to correlate the values
      final newRotationVector = Vector3(
        (widget.avatar.rotation.x * 100 * rotationScale).clamp(-100, 100),
        (widget.avatar.rotation.y * 100 * rotationScale).clamp(-100, 100),
        (widget.avatar.rotation.z * 100 * rotationScale).clamp(-100, 100),
      );
      if (newRotationVector.distance(previousRotationVector) >
          _rotationToleration) {
        _rotationTween
          ..begin = previousRotationVector
          ..end = newRotationVector;
        _rotationAnimationController.forward(from: 0);
      }

      final previousMouthValue = characterController.mouthDistance.value;
      final newMouthValue =
          (widget.avatar.mouthDistance * 100 * mouthScale).clamp(.0, 100.0);
      if ((previousMouthValue - newMouthValue).abs() > mouthToleration) {
        _mouthTween
          ..begin = previousMouthValue
          ..end = newMouthValue;
        _mouthAnimationController.forward(from: 0);
      }

      final previousLeftEyeValue = characterController.leftEyeIsClosed.value;
      final leftEyeGeometry = widget.avatar.leftEyeGeometry;
      late final double newLeftEyeValue;
      if (leftEyeGeometry.population > _eyePopulationMin &&
          leftEyeGeometry.minRatio != null &&
          leftEyeGeometry.meanRatio != null &&
          leftEyeGeometry.distance != null &&
          leftEyeGeometry.meanRatio! > leftEyeGeometry.minRatio! &&
          leftEyeGeometry.meanRatio! < leftEyeGeometry.maxRatio!) {
        final accurateNewLeftEyeValue = 100 -
            leftEyeGeometry.distance!.normalize(
              fromMin: leftEyeGeometry.minRatio!,
              fromMax: leftEyeGeometry.meanRatio!,
              toMax: 100,
            );

        if (accurateNewLeftEyeValue > _eyeClosureToleration) {
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

      final previousRightEyeValue = characterController.rightEyeIsClosed.value;
      final rightEyeGeometry = widget.avatar.rightEyeGeometry;
      late final double newRightEyeValue;
      if (rightEyeGeometry.population > _eyePopulationMin &&
          rightEyeGeometry.minRatio != null &&
          rightEyeGeometry.meanRatio != null &&
          rightEyeGeometry.distance != null &&
          rightEyeGeometry.meanRatio! > rightEyeGeometry.minRatio! &&
          rightEyeGeometry.meanRatio! < rightEyeGeometry.maxRatio!) {
        final accurateNewLeftEyeValue = 100 -
            rightEyeGeometry.distance!.normalize(
              fromMin: rightEyeGeometry.minRatio!,
              fromMax: rightEyeGeometry.meanRatio!,
              toMax: 100,
            );
        if (accurateNewLeftEyeValue > _eyeClosureToleration) {
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
        characterController.hats.change(
          widget.hat.index.toDouble(),
        );
      }
      if (oldWidget.glasses != widget.glasses) {
        characterController.glasses.change(
          widget.glasses.riveIndex,
        );
      }
      if (oldWidget.clothes != widget.clothes) {
        characterController.clothes.change(
          widget.clothes.index.toDouble(),
        );
      }
      if (oldWidget.handheldlLeft != widget.handheldlLeft) {
        characterController.handheldlLeft.change(
          widget.handheldlLeft.index.toDouble(),
        );
      }

      final newScale = widget.avatar.distance.normalize(
        fromMax: 1,
        toMin: 0.8,
        toMax: 5,
      );
      if ((newScale - _scale).abs() > _scaleToleration) {
        setState(() {
          _scale = newScale;
        });
      }
    }
  }

  @override
  void dispose() {
    characterController?.dispose();
    _rotationAnimationController.dispose();
    _leftEyeAnimationController.dispose();
    _rightEyeAnimationController.dispose();
    _mouthAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.riveImageSize.aspectRatio,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 400),
        child: widget.assetGenImage.rive(
          onInit: onRiveInit,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
