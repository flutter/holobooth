// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tensorflow_models/tensorflow_models.dart';
import 'package:test/test.dart';

class _MockTensorflowModelsPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements TensorflowModelsPlatform {}

class _MockFaceLandmarksDetector extends Mock implements FaceLandmarksDetector {
}

class _FakeEstimationConfig extends Fake implements EstimationConfig {}

class _FakeFace extends Fake implements Face {}

void main() {
  group('AvatarDetectorRepository', () {
    late AvatarDetectorRepository avatarDetectorRepository;
    late FaceLandmarksDetector faceLandmarksDetector;

    setUp(() {
      faceLandmarksDetector = _MockFaceLandmarksDetector();
      avatarDetectorRepository = AvatarDetectorRepository(
        faceLandmarksDetector: faceLandmarksDetector,
      );
    });

    setUpAll(() {
      registerFallbackValue(_FakeEstimationConfig());
    });

    test('can be instantiated', () {
      expect(AvatarDetectorRepository(), isNotNull);
    });

    group('initLandmarksModel', () {
      test('completes', () {
        final tensorflowModelsPlatform = _MockTensorflowModelsPlatform();
        TensorflowModelsPlatform.instance = tensorflowModelsPlatform;
        when(tensorflowModelsPlatform.loadFaceLandmark)
            .thenAnswer((_) async => _MockFaceLandmarksDetector());
        expect(avatarDetectorRepository.preloadLandmarksModel(), completes);
      });
    });

    group('detectFace', () {
      test('throws DetectFaceException if estimateFaces fails', () {
        when(
          () => faceLandmarksDetector.estimateFaces(
            '',
            estimationConfig: any(named: 'estimationConfig'),
          ),
        ).thenThrow(Exception());
        expect(
          avatarDetectorRepository.detectFace(''),
          throwsA(isA<DetectFaceException>()),
        );
      });

      test('throws FaceNotFoundException if estimateFaces returns empty list',
          () {
        when(
          () => faceLandmarksDetector.estimateFaces(
            '',
            estimationConfig: any(named: 'estimationConfig'),
          ),
        ).thenAnswer((_) async => List<Face>.empty());

        expect(
          avatarDetectorRepository.detectFace(''),
          throwsA(isA<FaceNotFoundException>()),
        );
      });

      test('return a Face', () async {
        when(
          () => faceLandmarksDetector.estimateFaces(
            '',
            estimationConfig: any(named: 'estimationConfig'),
          ),
        ).thenAnswer((_) async => <Face>[_FakeFace()]);
        await expectLater(
          avatarDetectorRepository.detectFace(''),
          completion(isA<Face>()),
        );
      });
    });
  });
}
