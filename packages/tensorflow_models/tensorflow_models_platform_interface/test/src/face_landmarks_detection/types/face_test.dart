import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

import '../../fixtures/estimatefaces.dart';

class _MockBoundingBox extends Mock implements tf.BoundingBox {}

class _MockKeypoint extends Mock implements tf.Keypoint {}

void main() {
  group('Face', () {
    late tf.BoundingBox boundingBox;
    late List<tf.Keypoint> keypoints;

    setUp(() {
      boundingBox = _MockBoundingBox();
      keypoints = List.empty();
    });

    test('can be deserialized from raw output', () {
      final jsonFaces = json.decode(estimateFacesOutput) as List;
      for (final jsonFace in jsonFaces) {
        expect(
          () => tf.Face.fromJson(jsonFace as Map<String, dynamic>),
          returnsNormally,
        );
      }
    });

    group('copyWith', () {
      test('returns normally', () {
        final subject = tf.Face(keypoints, boundingBox);
        expect(subject.copyWith, returnsNormally);
      });

      test('changes when properties are defined', () {
        final subject = tf.Face(
          keypoints,
          boundingBox,
        );

        final copy = subject.copyWith(
          boundingBox: _MockBoundingBox(),
          keypoints: [...keypoints, _MockKeypoint()],
        );

        expect(subject.keypoints, isNot(equals(copy.keypoints)));
        expect(subject.boundingBox, isNot(equals(copy.boundingBox)));
      });

      test('does nothing when there are no changes', () {
        final subject = tf.Face(
          keypoints,
          boundingBox,
        );
        final copy = subject.copyWith();

        expect(subject.keypoints, equals(copy.keypoints));
        expect(subject.boundingBox, equals(copy.boundingBox));
      });
    });
  });
}
