import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:rive/rive.dart';

class DashAnimation extends StatefulWidget {
  const DashAnimation({
    super.key,
    required this.avatar,
    required this.hat,
    required this.glasses,
    required this.clothes,
    required this.handheldlLeft,
  });

  final Avatar avatar;
  final Hats hat;
  final Glasses glasses;
  final Clothes clothes;
  final HandheldlLeft handheldlLeft;

  @override
  State<DashAnimation> createState() => DashAnimationState();
}

@visibleForTesting
class DashAnimationState extends State<DashAnimation>
    with TickerProviderStateMixin {
  static const _rotationToleration = 3;
  static const _eyeDistanceToleration = 10;

  @visibleForTesting
  DashStateMachineController? dashController;

  late final AnimationController _rotationAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 50),
  );

  late final AnimationController _leftEyeAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 70),
  );

  late final AnimationController _rightEyeAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 70),
  );

  final Tween<Offset> _rotationTween = Tween(
    begin: Offset.zero,
    end: Offset.zero,
  );

  final Tween<double> _leftEyeTween = Tween(
    begin: 0,
    end: 0,
  );

  final Tween<double> _rightEyeTween = Tween(
    begin: 0,
    end: 0,
  );

  void _onRiveInit(Artboard artboard) {
    dashController = DashStateMachineController(artboard);
    artboard.addController(dashController!);
    _rotationAnimationController.addListener(_controlRotation);
    _leftEyeAnimationController.addListener(_controlLeftEye);
    _rightEyeAnimationController.addListener(_controlRightEye);
  }

  void _controlRotation() {
    final dashController = this.dashController;
    if (dashController == null) return;

    final offset = _rotationTween.evaluate(_rotationAnimationController);
    dashController.x.change(offset.dx);
    dashController.y.change(offset.dy);
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
  void didUpdateWidget(covariant DashAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    final dashController = this.dashController;
    if (dashController != null) {
      final previousOffset =
          Offset(dashController.x.value, dashController.y.value);

      // Direction has range of values [-1,1], and the
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

      final previousLeftEyeValue = dashController.leftEyeIsClosed.value;
      final leftEyeGeometry = widget.avatar.leftEyeGeometry;
      late final double newLeftEyeValue;
      if (leftEyeGeometry.generation > 200 &&
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

        if (accurateNewLeftEyeValue > 20) {
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
      if (rightEyeGeometry.generation > 200 &&
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
        if (accurateNewLeftEyeValue > 20) {
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

      if (oldWidget.avatar.mouthDistance != widget.avatar.mouthDistance) {
        dashController.mouthDistance.change(
          widget.avatar.mouthDistance * 100,
        );
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
    return Assets.animations.dash.rive(
      onInit: _onRiveInit,
      fit: BoxFit.cover,
    );
  }
}

// TODO(oscar): remove on the scope of this task https://very-good-ventures-team.monday.com/boards/3161754080/pulses/3428762748
// coverage:ignore-start
@visibleForTesting
class DashStateMachineController extends StateMachineController {
  DashStateMachineController(Artboard artboard)
      : super(
          artboard.animations.whereType<StateMachine>().firstWhere(
                (stateMachine) => stateMachine.name == 'State Machine 1',
              ),
        ) {
    const xInputName = 'x';
    final x = findInput<double>(xInputName);
    if (x is SMINumber) {
      this.x = x;
    } else {
      throw StateError('Could not find input "$xInputName"');
    }

    const yInputName = 'y';
    final y = findInput<double>(yInputName);
    if (y is SMINumber) {
      this.y = y;
    } else {
      throw StateError('Could not find input "$yInputName"');
    }

    const mouthDistanceInputName = 'Mouth Open';
    final mouthDistance = findInput<double>(mouthDistanceInputName);
    if (mouthDistance is SMINumber) {
      this.mouthDistance = mouthDistance;
    } else {
      throw StateError('Could not find input "$mouthDistanceInputName"');
    }

    const leftEyeIsClosedInputName = 'Eyelid LF';
    final leftEyeIsClosed = findInput<double>(leftEyeIsClosedInputName);
    if (leftEyeIsClosed is SMINumber) {
      this.leftEyeIsClosed = leftEyeIsClosed;
    } else {
      throw StateError('Could not find input "$leftEyeIsClosedInputName"');
    }

    const rightEyeIsClosedInputName = 'Eyelid RT';
    final rightEyeIsClosed = findInput<double>(rightEyeIsClosedInputName);
    if (rightEyeIsClosed is SMINumber) {
      this.rightEyeIsClosed = rightEyeIsClosed;
    } else {
      throw StateError('Could not find input "$rightEyeIsClosedInputName"');
    }

    const hatsInputName = 'Hats';
    final hats = findInput<double>(hatsInputName);
    if (hats is SMINumber) {
      this.hats = hats;
    } else {
      throw StateError('Could not find input "$hatsInputName"');
    }

    const glassesInputName = 'Glasses';
    final glasses = findInput<double>(glassesInputName);
    if (glasses is SMINumber) {
      this.glasses = glasses;
    } else {
      throw StateError('Could not find input "$glassesInputName"');
    }

    const clothesInputName = 'Clothes';
    final clothes = findInput<double>(clothesInputName);
    if (clothes is SMINumber) {
      this.clothes = clothes;
    } else {
      throw StateError('Could not find input "$clothesInputName"');
    }

    const handheldLeftInputName = 'HandheldLeft';
    final handheldlLeft = findInput<double>(handheldLeftInputName);
    if (handheldlLeft is SMINumber) {
      this.handheldlLeft = handheldlLeft;
    } else {
      throw StateError('Could not find input "$handheldLeftInputName"');
    }
  }

  late final SMINumber x;
  late final SMINumber y;
  late final SMINumber mouthDistance;
  late final SMINumber leftEyeIsClosed;
  late final SMINumber rightEyeIsClosed;
  late final SMINumber hats;
  late final SMINumber glasses;
  late final SMINumber clothes;
  late final SMINumber handheldlLeft;
}
// coverage:ignore-end

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
