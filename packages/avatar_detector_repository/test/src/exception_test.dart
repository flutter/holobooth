// ignore_for_file: prefer_const_constructors

import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PreloadLandmarksModelException', () {
    test('overrides toString with message', () {
      final exception = PreloadLandmarksModelException('msg');
      expect(exception.toString(), 'msg');
    });
  });

  group('DetectAvatarException', () {
    test('overrides toString with message', () {
      final exception = DetectAvatarException('msg');
      expect(exception.toString(), 'msg');
    });
  });
}
