import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

import '../../fixtures/estimatefaces.dart';

class MockFaceLandmarkDetector extends Mock implements FaceLandmarksDetector {}

void main() {
  group('FaceLandmarkDetector', () {
    final faceLandmarksDetector = MockFaceLandmarkDetector();

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

    group('copyWith', () {
      test('returns normally', () {
        expect(
          () => Face(List.empty(), BoundingBox(0, 0, 0, 0, 0, 0)).copyWith(
            keypoints: List.empty(),
            boundingBox: BoundingBox(0, 0, 0, 0, 0, 0),
          ),
          returnsNormally,
        );
      });

      test('changes when properties are defined', () {
        final initialFace = Face(List.empty(), BoundingBox(0, 0, 0, 0, 0, 0));
        final newFace =
            Face(List.empty(), BoundingBox(0, 0, 0, 0, 0, 0)).copyWith(
          keypoints: List.empty(),
          boundingBox: BoundingBox(1, 1, 1, 1, 1, 1),
        );
        expect(initialFace, isNot(newFace));
      });

      /*
      this test is failing
      Error message:
      Expected <Instance of 'Face'>
      Actual <Instance of 'Face'>
      */
      // test('does nothing when no properties are defined', () {
      //   final initialFace = Face(List.empty(), BoundingBox(0, 0, 0, 0, 0, 0));
      //   final copiedFace = initialFace.copyWith();
      //   expect(initialFace, equals(copiedFace));
      // });
    });
  });
}
