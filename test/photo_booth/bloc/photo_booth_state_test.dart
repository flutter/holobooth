import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';

void main() {
  group('PhotoBoothState', () {
    test('supports value comparison if state is the same', () {
      final stateA = PhotoBoothState();
      final stateB = stateA.copyWith();
      expect(stateA, stateB);
    });

    test('supports value comparison if state is not the same', () {
      final stateA = PhotoBoothState();
      final stateB = stateA.copyWith(isRecording: true);
      expect(stateA, isNot(stateB));
    });
  });
}
