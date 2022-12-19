import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';

void main() {
  group('AvatarDetectorState', () {
    test('can be instantiated', () {
      const state = AvatarDetectorState();
      expect(state, isNotNull);
    });

    group('supports value comparison', () {
      test('by status', () {
        const state1 = AvatarDetectorState();
        final state2 = state1.copyWith();
        final state3 = state1.copyWith(
          status: AvatarDetectorStatus.loaded,
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
        expect(state2, isNot(equals(state3)));
      });

      test('by avatar', () {
        const avatar1 = Avatar(
          direction: Vector3(1, 1, 1),
          hasMouthOpen: false,
          mouthDistance: 0,
          leftEyeGeometry: LeftEyeGeometry.empty(),
          rightEyeGeometry: RightEyeGeometry.empty(),
          distance: 0.5,
        );
        final avatar2 = Avatar(
          direction: Vector3(1, 2, 3),
          mouthDistance: avatar1.mouthDistance + 1,
          hasMouthOpen: !avatar1.hasMouthOpen,
          leftEyeGeometry: LeftEyeGeometry.empty(),
          rightEyeGeometry: RightEyeGeometry.empty(),
          distance: avatar1.distance + 0.1,
        );

        final state1 = AvatarDetectorState(
          avatar: avatar1,
        );
        final state2 = AvatarDetectorState(
          avatar: avatar1,
        );
        final state3 = AvatarDetectorState(
          avatar: avatar2,
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
        expect(state2, isNot(equals(state3)));
      });
    });
  });

  group('AvatarDetectorStatus', () {
    group('hasLoadedModel', () {
      group('returns false', () {
        test('when status is AvatarDetectorStatus.initial', () {
          const status = AvatarDetectorStatus.initial;
          expect(status.hasLoadedModel, isFalse);
        });

        test('when status is AvatarDetectorStatus.loading', () {
          const status = AvatarDetectorStatus.loading;
          expect(status.hasLoadedModel, isFalse);
        });
        test('when status is AvatarDetectorStatus.error', () {
          const status = AvatarDetectorStatus.error;
          expect(status.hasLoadedModel, isFalse);
        });
      });

      group('returns true', () {
        test('when status is AvatarDetectorStatus.loaded', () {
          const status = AvatarDetectorStatus.loaded;
          expect(status.hasLoadedModel, isTrue);
        });

        test('when status is AvatarDetectorStatus.estimating', () {
          const status = AvatarDetectorStatus.estimating;
          expect(status.hasLoadedModel, isTrue);
        });

        test('when status is AvatarDetectorStatus.detected', () {
          const status = AvatarDetectorStatus.detected;
          expect(status.hasLoadedModel, isTrue);
        });

        test('when status is AvatarDetectorStatus.notDetected', () {
          const status = AvatarDetectorStatus.notDetected;
          expect(status.hasLoadedModel, isTrue);
        });
      });
    });
  });
}
