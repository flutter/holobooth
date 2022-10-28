import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';

void main() {
  group('PhotoBoothState', () {
    test('supports value comparison if state is the same', () {
      final stateA = PhotoBoothState.empty();
      final stateB = stateA.copyWith();
      expect(stateA, stateB);
    });

    test('supports value comparison if state is not the same', () {
      final stateA = PhotoBoothState.empty();
      final stateB = stateA.copyWith(
        images: UnmodifiableListView(
          [PhotoboothCameraImage(constraint: PhotoConstraint(), data: '')],
        ),
      );
      expect(stateA, isNot(stateB));
    });

    test(
        'throws assertion error if more than '
        'PhotoBoothState.totalNumberOfPhotos images', () {
      expect(
        () => PhotoBoothState(
          images: UnmodifiableListView(
            List.generate(
              PhotoBoothState.totalNumberOfPhotos + 1,
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
