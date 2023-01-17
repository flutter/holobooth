import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';
import 'package:holobooth/rive/rive.dart';
import 'package:platform_helper/platform_helper.dart';
import 'package:rive/rive.dart';

class DashCharacterAnimation extends CharacterAnimation {
  DashCharacterAnimation({
    super.key,
    required super.avatar,
    required super.hat,
    required super.glasses,
    required super.clothes,
    required super.handheldlLeft,
    PlatformHelper? platformHelper,
  }) : super(
          assetGenImage: (platformHelper ?? PlatformHelper()).isMobile
              ? Assets.animations.dashMobile
              : Assets.animations.dashDesktop,
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
    PlatformHelper? platformHelper,
  }) : super(
          assetGenImage: (platformHelper ?? PlatformHelper()).isMobile
              ? Assets.animations.sparkyMobile
              : Assets.animations.sparkyDesktop,
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

  /// The hat the character should wear.
  final Hats hat;

  /// The glasses the character should wear.
  final Glasses glasses;

  /// The clothes the character should wear.
  final Clothes clothes;

  /// The left handheld item the character should hold.
  final HandheldlLeft handheldlLeft;

  /// The character's [RiveGenImage].
  final RiveGenImage assetGenImage;

  /// The size of the character's [RiveGenImage].
  final Size riveImageSize;

  @override
  State<CharacterAnimation> createState() => CharacterAnimationState();
}

class CharacterAnimationState<T extends CharacterAnimation> extends State<T>
    with TickerProviderStateMixin {
  /// The amount of head movement required to trigger a rotation animation.
  ///
  /// The smaller the value the more sensitive the animation will be.
  @visibleForTesting
  static const rotationToleration = 3;

  /// The amount of time the eye will be closed for before it is considered to
  /// be a wink.
  @visibleForTesting
  static const eyeWinkDuration = Duration(milliseconds: 100);

  /// The amount of movement towards or from the camera required to trigger a
  /// scale animation.
  ///
  /// The smaller the value the more sensitive the animation will be.
  @visibleForTesting
  static const scaleToleration = .1;

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
    duration: const Duration(milliseconds: 150),
  );
  final Tween<double> _leftEyeTween = Tween(begin: 0, end: 0);
  DateTime? _leftEyeClosureTimestamp;

  late final AnimationController _rightEyeAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );
  final Tween<double> _rightEyeTween = Tween(begin: 0, end: 0);
  DateTime? _rightEyeClosureTimestamp;

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
    if (characterController == null) return;

    final vector = _rotationTween.evaluate(_rotationAnimationController);
    characterController.x.change(vector.x.clamp(-100, 100));
    characterController.y.change(vector.y.clamp(-100, 100));
    characterController.z.change(vector.z.clamp(-100, 100));
  }

  void _controlLeftEye() {
    final characterController = this.characterController;
    if (characterController == null) return;

    final distance = _leftEyeTween.evaluate(_leftEyeAnimationController);
    characterController.leftEye.change(distance);
  }

  void _controlRightEye() {
    final characterController = this.characterController;
    if (characterController == null) return;

    final distance = _rightEyeTween.evaluate(_rightEyeAnimationController);
    characterController.rightEye.change(distance);
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
    _scale = widget.avatar.distance.normalize(fromMax: 1, toMin: 0.8, toMax: 5);
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    final characterController = this.characterController;
    if (characterController == null) return;

    if (oldWidget.hat != widget.hat) {
      characterController.hats.change(
        widget.hat.index.toDouble(),
      );
    }
    if (oldWidget.glasses != widget.glasses) {
      characterController.glasses.change(
        widget.glasses.index.toDouble(),
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

    final previousRotationVector = Vector3(
      characterController.x.value,
      characterController.y.value,
      characterController.z.value,
    );
    final newRotationVector = Vector3(
      (widget.avatar.rotation.x * 100 * rotationScale).clamp(-100, 100),
      (widget.avatar.rotation.y * 100 * rotationScale).clamp(-100, 100),
      (widget.avatar.rotation.z * 100 * rotationScale).clamp(-100, 100),
    );
    if (newRotationVector.distance(previousRotationVector) >
        rotationToleration) {
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

    final previousLeftEyeValue = characterController.leftEye.value;
    final leftEyeGeometry = widget.avatar.leftEyeGeometry;
    late final double newLeftEyeValue;
    if (leftEyeGeometry.minRatio != null &&
        leftEyeGeometry.maxRatio != null &&
        leftEyeGeometry.meanRatio != null &&
        leftEyeGeometry.distance != null &&
        leftEyeGeometry.meanRatio! > leftEyeGeometry.minRatio! &&
        leftEyeGeometry.meanRatio! < leftEyeGeometry.maxRatio!) {
      if (leftEyeGeometry.isClosed) {
        _leftEyeClosureTimestamp ??= DateTime.now();
        newLeftEyeValue = 100;
      } else {
        newLeftEyeValue = 0;
      }
    } else {
      newLeftEyeValue = 0;
    }

    late final bool shouldAnimateLeftEye;
    final hasOpenedLeftEye = !leftEyeGeometry.isClosed &&
        _leftEyeClosureTimestamp != null &&
        !_leftEyeAnimationController.isAnimating;
    if (hasOpenedLeftEye) {
      _leftEyeClosureTimestamp = null;
      shouldAnimateLeftEye = hasOpenedLeftEye;
    } else {
      final startedWinkingLeftEye = leftEyeGeometry.isClosed &&
          previousLeftEyeValue == 0 &&
          _leftEyeClosureTimestamp != null &&
          DateTime.now().difference(_leftEyeClosureTimestamp!) >
              eyeWinkDuration;
      shouldAnimateLeftEye = startedWinkingLeftEye;
    }
    if (shouldAnimateLeftEye) {
      _leftEyeTween
        ..begin = previousLeftEyeValue
        ..end = newLeftEyeValue;
      _leftEyeAnimationController.forward(from: 0);
    }

    final previousRightEyeValue = characterController.rightEye.value;
    final rightEyeGeometry = widget.avatar.rightEyeGeometry;
    late final double newRightEyeValue;
    if (rightEyeGeometry.minRatio != null &&
        rightEyeGeometry.maxRatio != null &&
        rightEyeGeometry.meanRatio != null &&
        rightEyeGeometry.distance != null &&
        rightEyeGeometry.meanRatio! > rightEyeGeometry.minRatio! &&
        rightEyeGeometry.meanRatio! < rightEyeGeometry.maxRatio!) {
      if (rightEyeGeometry.isClosed) {
        _rightEyeClosureTimestamp ??= DateTime.now();
        newRightEyeValue = 100;
      } else {
        newRightEyeValue = 0;
      }
    } else {
      newRightEyeValue = 0;
    }
    late final bool shouldAnimateRightEye;
    final hasOpenedRightEye = !rightEyeGeometry.isClosed &&
        _rightEyeClosureTimestamp != null &&
        !_rightEyeAnimationController.isAnimating;
    if (hasOpenedRightEye) {
      _rightEyeClosureTimestamp = null;
      shouldAnimateRightEye = hasOpenedRightEye;
    } else {
      final startedWinkingRightEye = rightEyeGeometry.isClosed &&
          previousRightEyeValue == 0 &&
          _rightEyeClosureTimestamp != null &&
          DateTime.now().difference(_rightEyeClosureTimestamp!) >
              eyeWinkDuration;
      shouldAnimateRightEye = startedWinkingRightEye;
    }
    if (shouldAnimateRightEye) {
      _rightEyeTween
        ..begin = previousRightEyeValue
        ..end = newRightEyeValue;
      _rightEyeAnimationController.forward(from: 0);
    }

    final newScale =
        widget.avatar.distance.normalize(fromMax: 1, toMin: 0.8, toMax: 5);
    if ((newScale - _scale).abs() > scaleToleration) {
      setState(() => _scale = newScale);
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
        alignment: const Alignment(0, 5 / 6),
        duration: const Duration(milliseconds: 400),
        child: widget.assetGenImage.rive(
          onInit: onRiveInit,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
