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

  double _parseCoordinate(double value) {
    return num.parse((value * 100).toStringAsFixed(1)).toDouble();
  }

  double _numberDifference(double current, double previous) {
    return (current - previous).abs();
  }

  @override
  void didUpdateWidget(covariant BackgroundAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    final backgroundController = this.backgroundController;
    if (backgroundController != null) {
      /// Parallax effect
      const increment = 0.1;
      final currentX = _parseCoordinate(widget.x);
      final previousX = _parseCoordinate(oldWidget.x);
      final diffX = _numberDifference(currentX, previousX);
      if (diffX >= 1) {
        final factor = diffX / increment;
        var newValue = currentX + increment;
        for (var i = 0; i < factor; i++) {
          backgroundController.x.change(newValue);
          newValue = newValue + increment;
        }
      }

      final currentY = _parseCoordinate(widget.y);
      final previousY = _parseCoordinate(oldWidget.y);
      final diffY = _numberDifference(currentY, previousY);

      if (diffY >= 1) {
        final factor = diffY / increment;
        var newValue = currentY + increment;
        for (var i = 0; i < factor; i++) {
          backgroundController.y.change(newValue);
          newValue = newValue + increment;
        }
      }

      // Change background
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
