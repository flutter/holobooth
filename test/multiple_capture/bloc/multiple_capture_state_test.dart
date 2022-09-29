import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';

void main() {
  group('MultipleCaptureState', () {
    test('supports value comparison', () {
      final stateA = MultipleCaptureState.empty();
      final stateB = stateA.copyWith();
      expect(stateA, stateB);
    });

    test(
        'throws assertion error if more than '
        'MultipleCaptureState.totalNumberOfPhotos images', () {
      expect(
        () => MultipleCaptureState(
          images: UnmodifiableListView([
            for (var i = 0; i <= MultipleCaptureState.totalNumberOfPhotos; i++)
              PhotoboothCameraImage(constraint: PhotoConstraint(), data: '')
          ]),
        ),
        throwsAssertionError,
      );
    });
  });
}
