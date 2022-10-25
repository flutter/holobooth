import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/avatar_animation/avatar_animation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rive/rive.dart';

class _MockSMINumber extends Mock implements SMINumber {
  @override
  bool change(double value) {
    this.value = value;
    return true;
  }
}

class _MockSMIBool extends Mock implements SMIBool {
  _MockSMIBool(this.value);
  @override
  bool change(bool value) {
    this.value = value;
    return true;
  }

  @override
  final bool value;
}

class _MockDashStateMachineController extends Mock
    implements DashStateMachineController {
  @override
  SMINumber get x => _MockSMINumber();
  @override
  SMINumber get y => _MockSMINumber();
  @override
  SMIBool get openMouth => _MockSMIBool(true);

  @override
  bool init(CoreContext core) {
    return true;
  }

  @override
  ValueListenable<bool> get isActiveChanged => ValueNotifier(false);

  @override
  bool get isActive => true;
}

class MockArtboard extends Mock implements Artboard {}

void main() {
  group('DashAnimation', () {
    testWidgets('can update ', (tester) async {
      var avatar = Avatar(hasMouthOpen: false, direction: Vector3(0, 0, 0));

      late StateSetter stateSetter;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              stateSetter = setState;
              return DashAnimation(
                avatar: avatar,
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      final state =
          tester.state(find.byType(DashAnimation)) as DashAnimationState;
      final controller = state.dashController;
      expect(controller?.openMouth.value, false);
      stateSetter(
        () => avatar = Avatar(hasMouthOpen: true, direction: Vector3(0, 0, 0)),
      );
      await tester.pump();
      expect(controller?.openMouth.value, true);
    });
  });
}
