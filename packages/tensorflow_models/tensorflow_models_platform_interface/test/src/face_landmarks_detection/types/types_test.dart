// ignore_for_file: prefer_const_constructors

import 'dart:collection';
import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:test/test.dart';

import '../../fixtures/estimatefaces.dart';

class _MockBoundingBox extends Mock implements BoundingBox {}

class _MockKeypoint extends Mock implements Keypoint {}

class _TestFaceLandmarkDetector extends FaceLandmarksDetector {
  @override
  void dispose() {}

  @override
  Future<Faces> estimateFaces(
    dynamic object, {
    EstimationConfig estimationConfig = const EstimationConfig(),
  }) =>
      throw UnimplementedError();
}

void main() {
  group('FaceLandmarkDetector', () {
    test('can be instantiated', () {
      expect(
        _TestFaceLandmarkDetector(),
        isA<FaceLandmarksDetector>(),
      );
    });
  });
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

  group('Keypoint', () {
    test('can be instantiated', () {
      expect(
        Keypoint(1, 1, 1, 1, 'name'),
        isA<Keypoint>(),
      );
    });

    group('copyWith', () {
      test('returns normally', () {
        final subject = Keypoint(1, 1, 1, 1, 'name');
        expect(subject.copyWith, returnsNormally);
      });

      test('changes when properties are defined', () {
        final subject = Keypoint(1, 1, 1, 1, 'name');
        final copy = subject.copyWith(
          x: subject.x + 1,
          y: subject.y + 1,
          z: (subject.z ?? 0) + 1,
          score: (subject.score ?? 0) + 1,
          name: '${subject.name} copy',
        );

        expect(subject.x, isNot(equals(copy.x)));
        expect(subject.y, isNot(equals(copy.y)));
        expect(subject.z, isNot(equals(copy.z)));
        expect(subject.score, isNot(equals(copy.score)));
        expect(subject.name, isNot(equals(copy.name)));
      });

      test('remains the same if no changes are made', () {
        final subject = Keypoint(1, 1, 1, 1, 'name');
        final copy = subject.copyWith();

        expect(copy.x, equals(copy.x));
        expect(copy.y, equals(copy.y));
        expect(copy.z, equals(copy.z));
        expect(copy.score, equals(copy.score));
        expect(copy.name, equals(copy.name));
      });
    });
  });

  group('BoundingBox', () {
    test('can be instantiated', () {
      expect(
        BoundingBox(1, 1, 1, 1, 10, 10),
        isA<BoundingBox>(),
      );
    });

    group('copyWith', () {
      test('returns normally', () {
        final subject = BoundingBox(1, 1, 1, 1, 10, 10);
        expect(subject.copyWith, returnsNormally);
      });

      test('changes when properties are defined', () {
        final subject = BoundingBox(1, 1, 1, 1, 10, 10);
        final copy = subject.copyWith(
          xMin: subject.xMin + 1,
          yMin: subject.yMin + 1,
          xMax: subject.xMax + 1,
          yMax: subject.yMax + 1,
          width: subject.width + 1,
          height: subject.height + 1,
        );

        expect(subject.xMin, isNot(equals(copy.xMin)));
        expect(subject.yMin, isNot(equals(copy.yMin)));
        expect(subject.xMax, isNot(equals(copy.xMax)));
        expect(subject.yMax, isNot(equals(copy.yMax)));
        expect(subject.width, isNot(equals(copy.width)));
        expect(subject.height, isNot(equals(copy.height)));
      });

      test('remains the same if no changes are made', () {
        final subject = BoundingBox(1, 1, 1, 1, 10, 10);
        final copy = subject.copyWith();

        expect(subject.xMin, equals(copy.xMin));
        expect(subject.yMin, equals(copy.yMin));
        expect(subject.xMax, equals(copy.xMax));
        expect(subject.yMax, equals(copy.yMax));
        expect(subject.width, equals(copy.width));
        expect(subject.height, equals(copy.height));
      });
    });
  });

  group('EstimationConfig', () {
    test('can be instantiated', () {
      expect(
        EstimationConfig(),
        isA<EstimationConfig>(),
      );
    });

    group('flipHorizontal', () {
      test('false by default', () {
        expect(
          EstimationConfig().flipHorizontal,
          isFalse,
        );
      });
    });

    group('staticImageMode', () {
      test('true by default', () {
        expect(
          EstimationConfig().staticImageMode,
          isTrue,
        );
      });
    });
  });
}
