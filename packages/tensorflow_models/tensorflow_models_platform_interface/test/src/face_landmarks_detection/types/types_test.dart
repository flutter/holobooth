@TestOn('chrome')
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

import '../../fixtures/estimatefaces.dart';

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
  });
  group('Face', () {
    test('can be deserialized from raw output', () {
      final decodedFaces = json.decode(estimateFacesOutput) as List;
      for (final decodedFace in decodedFaces) {
        expect(
          () => Face.fromJson(decodedFace as Map<String, dynamic>),
          returnsNormally,
        );
      }
    });
    test('copyWith returns normally', () {
      expect(
        () => Face(List.empty(), BoundingBox(0, 0, 0, 0, 0, 0)).copyWith(
          keypoints: List.empty(),
          boundingBox: BoundingBox(0, 0, 0, 0, 0, 0),
        ),
        returnsNormally,
      );
    });
  });
}
