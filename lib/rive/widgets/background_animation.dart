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

  BackgroundAnimation.fromVector3(
    Vector3 direction, {
    Key? key,
    required Background backgroundSelected,
  }) : this(
          key: key,
          x: direction.x,
          y: direction.y,
          z: direction.z,
          backgroundSelected: backgroundSelected,
        );

  final double x;
  final double y;
  final double z;
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
    artboard.addController(backgroundController!);
  }

  @override
  void didUpdateWidget(covariant BackgroundAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    final backgroundController = this.backgroundController;
    if (backgroundController != null) {
      final x = widget.x;
      final currentX = num.parse((x * 100).toStringAsFixed(1)).toDouble();
      final test = backgroundController.x;
      final previousX =
          num.parse((oldWidget.x * 100).toStringAsFixed(1)).toDouble();
      final diffX = (currentX - previousX).abs();
      if (diffX >= 1) {
        final factor = diffX / 0.1;
        var newValue = currentX + 0.1;
        for (var i = 0; i < factor; i++) {
          backgroundController.x.change(newValue);
          newValue = newValue + 0.1;
          print('newvalue $newValue');
        }
      }

      final y = widget.y;
      final currentY = num.parse((y * 100).toStringAsFixed(1)).toDouble();
      final previousY =
          num.parse((oldWidget.y * 100).toStringAsFixed(1)).toDouble();
      final diffY = (currentY - previousY).abs();

      if (diffY >= 1.5) {
        backgroundController.y.change(currentY);
      }
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

  /// The total range [x] animates over.
  ///
  /// This data comes from the Rive file.
  static const _xRange = 200;

  /// The total range [y] animates over.
  ///
  /// This data comes from the Rive file.
  static const _yRange = 200;

  late final SMINumber x;
  late final SMINumber y;
  late final SMINumber z;
  late final SMINumber background;
}
// coverage:ignore-end

extension on Background {
  double toDouble() {
    switch (this) {
      case Background.space:
        return 1;
      case Background.forest:
        return 2;
    }
  }
}
