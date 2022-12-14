import 'package:flutter/material.dart';
import 'package:io_photobooth/rive/widgets/base_character_animation.dart';

class DashAnimation extends BaseCharacterAnimation {
  const DashAnimation({
    super.key,
    required super.avatar,
    required super.hat,
    required super.glasses,
    required super.clothes,
    required super.handheldlLeft,
    required super.assetGenImage,
  }) : super();

  @override
  State<DashAnimation> createState() => DashAnimationState();
}

@visibleForTesting
class DashAnimationState extends BaseCharacterAnimationState<DashAnimation> {
  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
