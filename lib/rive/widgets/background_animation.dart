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
class BackgroundAnimationState extends State<BackgroundAnimation>
    with TickerProviderStateMixin {
  @visibleForTesting
  BackgroundAnimationStateMachineController? backgroundController;

  void _onRiveInit(Artboard artboard) {
    backgroundController = BackgroundAnimationStateMachineController(artboard);
    artboard.addController(backgroundController!);

    _controller.addListener(() {
      final backgroundController = this.backgroundController;
      print('hello');
      if (backgroundController != null) {
        final offset = _tween.evaluate(_controller);
        print('offset $offset');
        backgroundController.x.change(offset.dx);
        backgroundController.y.change(offset.dy);
      }
    });
  }

  var latestValuesX = <double>[];
  var latestValuesY = <double>[];

  late final AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 200));

  Tween<Offset> _tween = Tween(begin: Offset.zero, end: Offset.zero);

  @override
  void didUpdateWidget(covariant BackgroundAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    final backgroundController = this.backgroundController;

    if (backgroundController != null) {
      if (latestValuesX.length == 5) {
        latestValuesX.removeAt(0);
      }
      latestValuesX.add(widget.x);
      final newX = latestValuesX.fold(
              0.0, (previousValue, element) => previousValue + element) /
          latestValuesX.length;

      if (latestValuesY.length == 5) {
        latestValuesY.removeAt(0);
      }
      latestValuesY.add(widget.y);
      final newY = latestValuesY.fold(
              0.0, (previousValue, element) => previousValue + element) /
          latestValuesY.length;

      final Offset previousOffset =
          Offset(backgroundController.x.value, backgroundController.y.value);
      final Offset newOffset = Offset(newX * 100, newY * 100);
      if ((newOffset - previousOffset).distance > 2) {
        _tween.begin = previousOffset;
        _tween.end = newOffset;
        _controller.forward(from: 0);
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
