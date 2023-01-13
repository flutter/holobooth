import 'package:flutter/widgets.dart';
import 'package:io_photobooth/assets/assets.dart';

class BackgroundAnimation extends StatefulWidget {
  const BackgroundAnimation({
    super.key,
    required this.assetGenImage,
  });

  final RiveGenImage assetGenImage;

  @override
  State<BackgroundAnimation> createState() => BackgroundAnimationState();
}

@visibleForTesting
class BackgroundAnimationState extends State<BackgroundAnimation> {
  @override
  Widget build(BuildContext context) {
    return widget.assetGenImage
        .rive(fit: BoxFit.cover, stateMachines: ['State Machine 1']);
  }
}
