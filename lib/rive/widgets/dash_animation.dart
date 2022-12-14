import 'package:flutter/material.dart';
import 'package:io_photobooth/rive/widgets/base_state.dart';

class DashAnimation extends BaseAnimation {
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
class DashAnimationState extends BaseAnimationState<DashAnimation> {
  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
