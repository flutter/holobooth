import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';

void main() {
  group('MultipleCaptureState', () {
    test('supports value comparison if state is the same', () {
      final stateA = MultipleCaptureState.empty();
      final stateB = stateA.copyWith();
      expect(stateA, stateB);
    });

    test('supports value comparison if state is not the same', () {
      final stateA = MultipleCaptureState.empty();
      final stateB = stateA.copyWith(
        images: UnmodifiableListView(
          [PhotoboothCameraImage(constraint: PhotoConstraint(), data: '')],
        ),
      );
      expect(stateA, isNot(stateB));
    });

    test(
        'throws assertion error if more than '
        'MultipleCaptureState.totalNumberOfPhotos images', () {
      expect(
        () => MultipleCaptureState(
          images: UnmodifiableListView(
            List.generate(
              MultipleCaptureState.totalNumberOfPhotos,
              (_) => PhotoboothCameraImage(
                constraint: PhotoConstraint(),
                data: '',
              ),
            ),
          ),
        ),
        throwsAssertionError,
      );
    });
  });
}
