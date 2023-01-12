import 'package:flutter/widgets.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:rive/rive.dart';

class BackgroundAnimation extends StatefulWidget {
  const BackgroundAnimation({
    super.key,
    required this.backgroundSelected,
  });

  final Background backgroundSelected;

  @override
  State<BackgroundAnimation> createState() => BackgroundAnimationState();
}

@visibleForTesting
class BackgroundAnimationState extends State<BackgroundAnimation> {
  @visibleForTesting
  BackgroundAnimationStateMachineController? backgroundController;

  void _onRiveInit(Artboard artboard) {
    backgroundController = BackgroundAnimationStateMachineController(artboard);
    backgroundController!.background
        .change(widget.backgroundSelected.riveIndex);
    artboard.addController(backgroundController!);
  }

  @override
  void didUpdateWidget(covariant BackgroundAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    final backgroundController = this.backgroundController;

    if (backgroundController != null) {
      final newBackground = widget.backgroundSelected;
      final oldBackground = oldWidget.backgroundSelected;
      if (newBackground != oldBackground) {
        backgroundController.background
            .change(widget.backgroundSelected.riveIndex);
      }
    }
  }

  @override
  void dispose() {
    backgroundController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Assets.animations.background.rive(
      onInit: _onRiveInit,
      fit: BoxFit.cover,
    );
  }
}

@visibleForTesting
class BackgroundAnimationStateMachineController extends StateMachineController {
  BackgroundAnimationStateMachineController(
    Artboard artboard, {
    SMIInput<dynamic>? Function(String name)? testFindInput,
  }) : super(
          testFindInput == null
              ? artboard.animations.whereType<StateMachine>().firstWhere(
                    (stateMachine) => stateMachine.name == 'State Machine 1',
                  )
              : StateMachine(),
        ) {
    final x = testFindInput != null
        ? testFindInput(xInputName)
        : findInput<double>(xInputName);
    if (x is SMINumber) {
      this.x = x;
    } else {
      throw StateError('Could not find input "$xInputName"');
    }

    final y = testFindInput != null
        ? testFindInput(yInputName)
        : findInput<double>(yInputName);
    if (y is SMINumber) {
      this.y = y;
    } else {
      throw StateError('Could not find input "$yInputName"');
    }

    final z = testFindInput != null
        ? testFindInput(zInputName)
        : findInput<double>(zInputName);
    if (z is SMINumber) {
      this.z = z;
    } else {
      throw StateError('Could not find input "$zInputName"');
    }

    final background = testFindInput != null
        ? testFindInput(backgroundInputName)
        : findInput<double>(backgroundInputName);
    if (background is SMINumber) {
      this.background = background;
    } else {
      throw StateError('Could not find input "$backgroundInputName"');
    }
  }

  @visibleForTesting
  static const xInputName = 'X';

  @visibleForTesting
  static const yInputName = 'Y';

  @visibleForTesting
  static const zInputName = 'Z';

  @visibleForTesting
  static const backgroundInputName = 'BG';

  late final SMINumber x;
  late final SMINumber y;
  late final SMINumber z;
  late final SMINumber background;
}
