import 'package:flutter/widgets.dart';
import 'package:io_photobooth/assets/assets.dart';

class BackgroundAnimation extends StatefulWidget {
  const BackgroundAnimation({
    super.key,
    required this.riveGenImage,
  });

  final RiveGenImage riveGenImage;

  @override
  State<BackgroundAnimation> createState() => BackgroundAnimationState();
}

@visibleForTesting
class BackgroundAnimationState extends State<BackgroundAnimation> {
  @override
  Widget build(BuildContext context) {
    return widget.riveGenImage
        .rive(fit: BoxFit.cover, stateMachines: ['State Machine 1']);
  }
}
