import 'package:example/assets/assets.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:screen_recorder/screen_recorder.dart';

class DashWithBackground extends StatefulWidget {
  const DashWithBackground({
    Key? key,
    required this.faceGeometry,
    this.screenRecorderController,
  }) : super(key: key);

  final FaceGeometry? faceGeometry;
  final ScreenRecorderController? screenRecorderController;

  @override
  State<DashWithBackground> createState() => _DashWithBackgroundState();
}

class _DashWithBackgroundState extends State<DashWithBackground> {
  _DashStateMachineController? _dashController;

  void _onRiveInit(Artboard artboard) {
    _dashController = _DashStateMachineController(artboard);
    artboard.addController(_dashController!);
  }

  @override
  void didUpdateWidget(covariant DashWithBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    final dashController = _dashController;
    if (dashController != null && widget.faceGeometry != null) {
      final direction = widget.faceGeometry!.direction.value;
      _dashController?.x.change(
        -direction.x * ((_DashStateMachineController._xRange / 2) + 50),
      );
    }
  }

  @override
  void dispose() {
    _dashController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.screenRecorderController != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return ScreenRecorder(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            controller: widget.screenRecorderController!,
            child: Assets.dashWithBackground.rive(
              onInit: _onRiveInit,
              fit: BoxFit.contain,
              artboard: 'bg',
            ),
          );
        },
      );
    }
    return Assets.dashWithBackground.rive(
      onInit: _onRiveInit,
      fit: BoxFit.contain,
      artboard: 'bg',
    );
  }
}

class _DashStateMachineController extends StateMachineController {
  _DashStateMachineController(Artboard artboard)
      : super(
          artboard.animations.whereType<StateMachine>().firstWhere(
                (stateMachine) => stateMachine.name == 'State Machine 1',
              ),
        ) {
    final bg = findInput<double>('BG');
    if (bg is SMINumber) {
      this.bg = bg;
    } else {
      throw StateError('Could not find input "bg"');
    }
    final x = findInput<double>('X');
    if (x is SMINumber) {
      this.x = x;
    } else {
      throw StateError('Could not find input "X"');
    }
  }

  late final SMINumber bg;
  late final SMINumber x;

  /// The total range [x] animates over.
  ///
  /// This data comes from the Rive file.
  static const _xRange = 200;
}
