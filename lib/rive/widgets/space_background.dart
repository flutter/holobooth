import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/widgets.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:rive/rive.dart';

class SpaceBackground extends StatefulWidget {
  const SpaceBackground({
    super.key,
    required this.x,
    required this.y,
    required this.z,
  });

  SpaceBackground.fromVector3(
    Vector3 direction, {
    Key? key,
  }) : this(
          key: key,
          x: direction.x,
          y: direction.y,
          z: direction.z,
        );

  final double x;
  final double y;
  final double z;

  @override
  State<SpaceBackground> createState() => SpaceBackgroundState();
}

@visibleForTesting
class SpaceBackgroundState extends State<SpaceBackground> {
  @visibleForTesting
  SpaceBackgroundStateMachineController? backgroundController;

  void _onRiveInit(Artboard artboard) {
    backgroundController = SpaceBackgroundStateMachineController(artboard);
    artboard.addController(backgroundController!);
  }

  @override
  void didUpdateWidget(covariant SpaceBackground oldWidget) {
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
class SpaceBackgroundStateMachineController extends StateMachineController {
  SpaceBackgroundStateMachineController(Artboard artboard)
      : super(
          artboard.animations
              .whereType<StateMachine>()
              .firstWhere((stateMachine) => stateMachine.name == 'background'),
        ) {
    const xInputName = 'x';
    final x = findInput<double>(xInputName);
    if (x is SMINumber) {
      this.x = x;
    } else {
      throw StateError('Could not find input "$xInputName"');
    }

    const yInputName = 'y';
    final y = findInput<double>(yInputName);
    if (y is SMINumber) {
      this.y = y;
    } else {
      throw StateError('Could not find input "$yInputName"');
    }

    const zInputName = 'z';
    final z = findInput<double>(zInputName);
    if (z is SMINumber) {
      this.z = z;
    } else {
      throw StateError('Could not find input "$zInputName"');
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
}
// coverage:ignore-end
