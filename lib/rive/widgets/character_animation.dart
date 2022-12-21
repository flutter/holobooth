import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/rive/rive.dart';
import 'package:rive/rive.dart';

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

  /// Creates a [CharacterAnimation] for the Dash character.
  CharacterAnimation.dash({
    Key? key,
    required Avatar avatar,
    required Hats hat,
    required Glasses glasses,
    required Clothes clothes,
    required HandheldlLeft handheldlLeft,
  }) : this(
          key: key,
          avatar: avatar,
          hat: hat,
          glasses: glasses,
          clothes: clothes,
          handheldlLeft: handheldlLeft,
          assetGenImage: Assets.animations.dash,
          riveImageSize: const Size(2400, 2100),
        );

  /// Creates a [CharacterAnimation] for the Sparky character.
  CharacterAnimation.sparky({
    Key? key,
    required Avatar avatar,
    required Hats hat,
    required Glasses glasses,
    required Clothes clothes,
    required HandheldlLeft handheldlLeft,
  }) : this(
          key: key,
          avatar: avatar,
          hat: hat,
          glasses: glasses,
          clothes: clothes,
          handheldlLeft: handheldlLeft,
          assetGenImage: Assets.animations.sparky,
          riveImageSize: const Size(2500, 2100),
        );

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

  static const _scaleToleration = .1;

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

  late double _scale;

  void onRiveInit(Artboard artboard) {
    characterController = CharacterStateMachineController(artboard);
    artboard.addController(characterController!);
    _rotationAnimationController.addListener(_controlDashPosition);
    _leftEyeAnimationController.addListener(_controlLeftEye);
    _rightEyeAnimationController.addListener(_controlRightEye);
  }

  void _controlDashPosition() {
    final characterController = this.characterController;
    if (characterController != null) {
      final vector = _rotationTween.evaluate(_rotationAnimationController);
      characterController.x.change(vector.x);
      characterController.y.change(vector.y);
      characterController.z.change(vector.z);
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
        widget.avatar.direction.x * 100,
        widget.avatar.direction.y * 100,
        widget.avatar.direction.z * 100,
      );
      if (newRotationVector.distance(previousRotationVector) >
          _rotationToleration) {
        _rotationTween
          ..begin = previousRotationVector
          ..end = newRotationVector;
        _rotationAnimationController.forward(from: 0);
      }

      if (oldWidget.avatar.mouthDistance != widget.avatar.mouthDistance) {
        characterController.mouthDistance.change(
          widget.avatar.mouthDistance * 100,
        );
      }

      final previousLeftEyeValue = characterController.leftEyeIsClosed.value;
      final leftEyeGeometry = widget.avatar.leftEyeGeometry;
      late final double newLeftEyeValue;
      if (leftEyeGeometry.generation > _eyePopulationMin &&
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
      if (rightEyeGeometry.generation > _eyePopulationMin &&
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
        toMin: 0.6,
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
