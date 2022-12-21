import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/rive/widgets/base_character_animation.dart';

class SparkyAnimation extends BaseCharacterAnimation {
  SparkyAnimation({
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

  @override
  State<SparkyAnimation> createState() =>
      BaseCharacterAnimationState<SparkyAnimation>();
}
