import 'dart:collection';
import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:test/test.dart';

import '../../fixtures/estimatefaces.dart';

class _MockBoundingBox extends Mock implements BoundingBox {}

class _MockKeypoint extends Mock implements Keypoint {}

void main() {
  group('Face', () {
    late BoundingBox boundingBox;
    late UnmodifiableListView<Keypoint> keypoints;

    setUp(() {
      boundingBox = _MockBoundingBox();
      keypoints = UnmodifiableListView(List.empty());
    });

    group('fromJson', () {
      test('can be deserialized from raw output', () {
        final jsonFaces = json.decode(estimateFacesOutput) as List;

        for (final jsonFace in jsonFaces) {
          final face = Face.fromJson(jsonFace as Map<String, dynamic>);
          expect(face.keypoints, isNotEmpty);
          expect(face.keypoints.first, isA<Keypoint>());
        }
      });
    });

    group('copyWith', () {
      test('returns normally', () {
        final subject = Face(keypoints, boundingBox);
        expect(subject.copyWith, returnsNormally);
      });

      test('changes when properties are defined', () {
        final subject = Face(
          keypoints,
          boundingBox,
        );

        final copy = subject.copyWith(
          boundingBox: _MockBoundingBox(),
          keypoints: UnmodifiableListView([...keypoints, _MockKeypoint()]),
        );

        expect(subject.keypoints, isNot(equals(copy.keypoints)));
        expect(subject.boundingBox, isNot(equals(copy.boundingBox)));
      });

      test('does nothing when there are no changes', () {
        final subject = Face(
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
