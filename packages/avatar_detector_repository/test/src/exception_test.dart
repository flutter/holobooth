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

  group('DetectFaceException', () {
    test('overrides toString with message', () {
      final exception = DetectFaceException('msg');
      expect(exception.toString(), 'msg');
    });
  });

  group('FaceNotFoundException', () {
    test('overrides toString with message', () {
      final exception = FaceNotFoundException('msg');
      expect(exception.toString(), 'msg');
    });
  });
}
