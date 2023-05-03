import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

class BackgroundAnimation extends StatefulWidget {
  const BackgroundAnimation({
    required this.riveFile,
    super.key,
  });

  final RiveFile riveFile;

  @override
  State<BackgroundAnimation> createState() => BackgroundAnimationState();
}

@visibleForTesting
class BackgroundAnimationState extends State<BackgroundAnimation> {
  @override
  Widget build(BuildContext context) {
    return RiveAnimation.direct(
      widget.riveFile,
      key: ValueKey(widget.riveFile),
      fit: BoxFit.cover,
      stateMachines: const ['State Machine 1'],
    );
  }
}
