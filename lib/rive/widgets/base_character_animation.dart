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
  @visibleForTesting
  CharacterStateMachineController? dashController;

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 50),
  );

  final Tween<Offset> _tween = Tween(begin: Offset.zero, end: Offset.zero);

  static const _distanceToleration = 3;

  void onRiveInit(Artboard artboard) {
    dashController = CharacterStateMachineController(artboard);
    artboard.addController(dashController!);
    _animationController.addListener(_controlDashPosition);
  }

  void _controlDashPosition() {
    final dashController = this.dashController;
    if (dashController != null) {
      final offset = _tween.evaluate(_animationController);
      dashController.x.change(offset.dx);
      dashController.y.change(offset.dy);
    }
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
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
      if ((newOffset - previousOffset).distance > _distanceToleration) {
        _tween
          ..begin = previousOffset
          ..end = newOffset;
        _animationController.forward(from: 0);
      }
      if (oldWidget.avatar.mouthDistance != widget.avatar.mouthDistance) {
        dashController.mouthDistance.change(
          widget.avatar.mouthDistance * 100,
        );
      }
      if (oldWidget.avatar.rightEyeIsClosed != widget.avatar.rightEyeIsClosed) {
        dashController.rightEyeIsClosed.change(
          widget.avatar.rightEyeIsClosed ? 99 : 0,
        );
      }
      if (oldWidget.avatar.leftEyeIsClosed != widget.avatar.leftEyeIsClosed) {
        dashController.leftEyeIsClosed.change(
          widget.avatar.leftEyeIsClosed ? 99 : 0,
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
    return widget.assetGenImage.rive(
      onInit: onRiveInit,
      fit: BoxFit.cover,
    );
  }
}
