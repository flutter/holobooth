import 'package:face_geometry/face_geometry.dart';
import 'package:test/test.dart';

void main() {
  const boundingBoxHeight = 200.0;

  group('FaceEye', () {
    test('can be initialized', () {
      expect(FaceEye.new, returnsNormally);
    });

    group('isClose', () {
      test('returns false when distance is too small', () {
        final eyeBlink = FaceEye();
        final isEyeClose = eyeBlink.isClose(
          eyeDistance: 0,
          boundingBoxHeight: boundingBoxHeight,
        );

        expect(isEyeClose, false);
      });

      test('returns true on blink', () {
        final eyeBlink = FaceEye()
          ..isClose(
            eyeDistance: 50,
            boundingBoxHeight: boundingBoxHeight,
          );
        final isEyeClose = eyeBlink.isClose(
          eyeDistance: 10,
          boundingBoxHeight: boundingBoxHeight,
        );

        expect(isEyeClose, true);
      });
    });
  });
}
