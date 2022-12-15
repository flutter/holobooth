import 'package:flutter/material.dart';
import 'package:io_photobooth/rive/widgets/base_character_animation.dart';

class SparkyAnimation extends BaseCharacterAnimation {
  const SparkyAnimation({
    super.key,
    required super.avatar,
    required super.hat,
    required super.glasses,
    required super.clothes,
    required super.handheldlLeft,
    required super.assetGenImage,
  });

  @override
  State<SparkyAnimation> createState() =>
      BaseCharacterAnimationState<SparkyAnimation>();
}
