import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/rive/widgets/base_character_animation.dart';

class DashAnimation extends BaseCharacterAnimation {
  DashAnimation({
    super.key,
    required super.avatar,
    required super.hat,
    required super.glasses,
    required super.clothes,
    required super.handheldlLeft,
  }) : super(
          assetGenImage: Assets.animations.dash,
          riveImageSize: const Size(2100, 2100),
        );

  @override
  State<DashAnimation> createState() =>
      BaseCharacterAnimationState<DashAnimation>();
}
