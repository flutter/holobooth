import 'package:flutter/material.dart';
import 'package:io_photobooth/rive/widgets/base_state.dart';

class SparkyAnimation extends BaseAnimation {
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
  State<SparkyAnimation> createState() => SparkyAnimationState();
}

@visibleForTesting
class SparkyAnimationState extends BaseAnimationState<SparkyAnimation> {
  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
