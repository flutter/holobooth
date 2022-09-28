import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';

void main() {
  group('MultipleCaptureState', () {
    test('supports value comparison', () {
      final stateA = MultipleCaptureState.empty();
      final stateB = stateA.copyWith();
      expect(stateA, stateB);
    });
  });
}
