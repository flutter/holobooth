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
          keypoints: List.filled(1, Keypoint(1, 1, 1, 1, 'name')),
          boundingBox: BoundingBox(1, 1, 1, 1, 1, 1),
        );

        expect(initialFace.keypoints, isNot(equals(newFace.keypoints)));
        expect(initialFace.boundingBox, isNot(equals(newFace.boundingBox)));
      });

      test('does nothing when there are no changes', () {
        final initialFace = Face(List.empty(), BoundingBox(0, 0, 0, 0, 0, 0));

        final copiedFace = initialFace.copyWith();

        expect(initialFace.keypoints, equals(copiedFace.keypoints));
        expect(initialFace.boundingBox, equals(copiedFace.boundingBox));
      });
    });
  });
  group('Keypoint', () {
    test('can be instantiated', () {
      expect(Keypoint, isNotNull);
    });
    group('copyWith', () {
      test('returns normally', () {
        final initialKeypoint = Keypoint(1, 1, 1, 1, 'name');

        expect(initialKeypoint.copyWith, returnsNormally);
      });

      test('changes when properties are defined', () {
        final initialKeypoint = Keypoint(1, 1, 1, 1, 'name');
        final newKeypoint = initialKeypoint.copyWith(
          x: 2,
          y: 2,
          z: 2,
          score: 2,
          name: 'new name',
        );

        expect(initialKeypoint.x, isNot(equals(newKeypoint.x)));
        expect(initialKeypoint.y, isNot(equals(newKeypoint.y)));
        expect(initialKeypoint.z, isNot(equals(newKeypoint.z)));
        expect(initialKeypoint.score, isNot(equals(newKeypoint.score)));
        expect(initialKeypoint.name, isNot(equals(newKeypoint.name)));
      });

      test('remains the same if no changes are made', () {
        final initialKeypoint = Keypoint(1, 1, 1, 1, 'name');
        final newKeypoint = initialKeypoint.copyWith();

        expect(newKeypoint.x, equals(newKeypoint.x));
        expect(newKeypoint.y, equals(newKeypoint.y));
        expect(newKeypoint.z, equals(newKeypoint.z));
        expect(newKeypoint.score, equals(newKeypoint.score));
        expect(newKeypoint.name, equals(newKeypoint.name));
      });
    });
  });
  group('BoundingBox', () {
    test('can be instantiated', () {
      expect(BoundingBox, isNotNull);
    });
    group('copyWith', () {
      test('returns normally', () {
        final initialBox = BoundingBox(1, 1, 1, 1, 10, 10);
        expect(initialBox.copyWith, returnsNormally);
      });

      test('changes when properties are defined', () {
        final initialBox = BoundingBox(1, 1, 1, 1, 10, 10);
        final newBox = initialBox.copyWith(
          xMin: 2,
          yMin: 2,
          xMax: 2,
          yMax: 2,
          width: 20,
          height: 20,
        );

        expect(initialBox.xMin, isNot(equals(newBox.xMin)));
        expect(initialBox.yMin, isNot(equals(newBox.yMin)));
        expect(initialBox.xMax, isNot(equals(newBox.xMax)));
        expect(initialBox.yMax, isNot(equals(newBox.yMax)));
        expect(initialBox.width, isNot(equals(newBox.width)));
        expect(initialBox.height, isNot(equals(newBox.height)));
      });

      test('remains the same if no changes are made', () {
        final initialBox = BoundingBox(1, 1, 1, 1, 10, 10);
        final newBox = initialBox.copyWith();

        expect(initialBox.xMin, equals(newBox.xMin));
        expect(initialBox.yMin, equals(newBox.yMin));
        expect(initialBox.xMax, equals(newBox.xMax));
        expect(initialBox.yMax, equals(newBox.yMax));
        expect(initialBox.width, equals(newBox.width));
        expect(initialBox.height, equals(newBox.height));
      });
    });
  });
}
