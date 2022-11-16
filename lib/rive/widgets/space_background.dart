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
  State<SpaceBackground> createState() => _SpaceBackgroundState();
}

class _SpaceBackgroundState extends State<SpaceBackground> {
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
      final y = widget.y;
      backgroundController.x.change(
        x * ((SpaceBackgroundStateMachineController._xRange / 2) + 50),
      );
      backgroundController.y.change(
        y * ((SpaceBackgroundStateMachineController._yRange / 2) + 50),
      );
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

  /// The total range [z] animates over.
  ///
  /// This data comes from the Rive file.
  static const _zRange = 200;

  /// The total size of the rive artboard.
  static const Size size = Size(2000, 2000);

  late final SMINumber x;
  late final SMINumber y;
  late final SMINumber z;
}
