import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/widgets.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:rive/rive.dart';

class BackgroundAnimation extends StatefulWidget {
  const BackgroundAnimation({
    super.key,
    required this.x,
    required this.y,
    required this.z,
    required this.backgroundSelected,
  });

  final double x;
  final double y;
  final double z;
  final Background backgroundSelected;

  @override
  State<BackgroundAnimation> createState() => BackgroundAnimationState();
}

@visibleForTesting
class BackgroundAnimationState extends State<BackgroundAnimation>
    with TickerProviderStateMixin {
  @visibleForTesting
  BackgroundAnimationStateMachineController? backgroundController;

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );

  final Tween<Vector3> _tween = Tween(begin: Vector3.zero, end: Vector3.zero);

  void _onRiveInit(Artboard artboard) {
    backgroundController = BackgroundAnimationStateMachineController(artboard);
    backgroundController!.background
        .change(widget.backgroundSelected.toDouble());
    artboard.addController(backgroundController!);
    _animationController.addListener(_controlBackground);
  }

  void _controlBackground() {
    final backgroundController = this.backgroundController;
    if (backgroundController != null) {
      final offset = _tween.evaluate(_animationController);
      backgroundController.x.change(offset.x);
      backgroundController.y.change(offset.y);
      backgroundController.z.change(offset.z);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  void didUpdateWidget(covariant BackgroundAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    final backgroundController = this.backgroundController;
    if (backgroundController == null) return;

    final previousVector = Vector3(
      backgroundController.x.value,
      backgroundController.y.value,
      backgroundController.z.value,
    );
    final newVector = Vector3(
      widget.x * 100,
      widget.y * 100,
      widget.z * 100,
    );
    if ((newVector - previousVector).length > 5) {
      _tween
        ..begin = previousVector
        ..end = newVector;
      _animationController.forward(from: 0);
    }

    final newBackground = widget.backgroundSelected;
    final oldBackground = oldWidget.backgroundSelected;
    if (newBackground != oldBackground) {
      backgroundController.background
          .change(widget.backgroundSelected.toDouble());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Assets.animations.background.rive(
      onInit: _onRiveInit,
      fit: BoxFit.cover,
    );
  }
}

// TODO(oscar): remove on the scope of this task https://very-good-ventures-team.monday.com/boards/3161754080/pulses/3428762748
// coverage:ignore-start
@visibleForTesting
class BackgroundAnimationStateMachineController extends StateMachineController {
  BackgroundAnimationStateMachineController(Artboard artboard)
      : super(
          artboard.animations.whereType<StateMachine>().firstWhere(
                (stateMachine) => stateMachine.name == 'State Machine 1',
              ),
        ) {
    const xInputName = 'X';
    final x = findInput<double>(xInputName);
    if (x is SMINumber) {
      this.x = x;
    } else {
      throw StateError('Could not find input "$xInputName"');
    }

    const yInputName = 'Y';
    final y = findInput<double>(yInputName);
    if (y is SMINumber) {
      this.y = y;
    } else {
      throw StateError('Could not find input "$yInputName"');
    }

    const zInputName = 'Z';
    final z = findInput<double>(zInputName);
    if (z is SMINumber) {
      this.z = z;
    } else {
      throw StateError('Could not find input "$zInputName"');
    }

    const backgroundInputName = 'BG';
    final background = findInput<double>(backgroundInputName);
    if (background is SMINumber) {
      this.background = background;
    } else {
      throw StateError('Could not find input "$backgroundInputName"');
    }
  }

  late final SMINumber x;
  late final SMINumber y;
  late final SMINumber z;
  late final SMINumber background;
}
// coverage:ignore-end
