import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';

void main() {
  group('AvatarDetectorState', () {
    group('AvatarDetectorInitial', () {
      test('supports value comparison', () {
        expect(AvatarDetectorInitial(), AvatarDetectorInitial());
      });
    });
  });
}
