import 'package:flutter_test/flutter_test.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:mocktail/mocktail.dart';

class MockFaceLAndmarkDetector extends Mock implements FaceLandmarksDetector {}

void main() {
  late FaceLandmarksDetector faceLandmarksDetector;
  setUp(() {
    faceLandmarksDetector = MockFaceLAndmarkDetector();
  });
  group('FaceLandmarkDetector', () {
    test('can be instantiated', () {
      expect(faceLandmarksDetector, isNotNull);
    });

    test('estimate faces', () {});
  });
}
