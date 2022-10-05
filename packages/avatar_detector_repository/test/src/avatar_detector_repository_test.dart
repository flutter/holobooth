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
    late TensorflowModelsPlatform tensorflowModelsPlatform;

    setUp(() {
      tensorflowModelsPlatform = _MockTensorflowModelsPlatform();
      TensorflowModelsPlatform.instance = tensorflowModelsPlatform;
      faceLandmarksDetector = _MockFaceLandmarksDetector();
      avatarDetectorRepository = AvatarDetectorRepository();
      when(() => tensorflowModelsPlatform.loadFaceLandmark())
          .thenAnswer((_) async => faceLandmarksDetector);
    });

    setUpAll(() {
      registerFallbackValue(_FakeEstimationConfig());
    });

    test('can be instantiated', () {
      expect(AvatarDetectorRepository(), isNotNull);
    });

    group('initLandmarksModel', () {
      test('throws PreloadLandmarksModelException if any exception occurs', () {
        when(() => tensorflowModelsPlatform.loadFaceLandmark())
            .thenThrow(Exception());
        expect(
          avatarDetectorRepository.preloadLandmarksModel(),
          throwsA(isA<PreloadLandmarksModelException>()),
        );
      });

      test('completes', () {
        when(tensorflowModelsPlatform.loadFaceLandmark)
            .thenAnswer((_) async => _MockFaceLandmarksDetector());
        expect(avatarDetectorRepository.preloadLandmarksModel(), completes);
      });
    });

    group('detectFace', () {
      test(
          'calls preloadLandmarksModel if '
          'faceLandmarksDetector is not initialized yet', () async {
        when(
          () => faceLandmarksDetector.estimateFaces(
            '',
            estimationConfig: any(named: 'estimationConfig'),
          ),
        ).thenAnswer((_) async => <Face>[_FakeFace()]);
        await avatarDetectorRepository.detectFace('');
        verify(() => tensorflowModelsPlatform.loadFaceLandmark()).called(1);
      });

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

      test('returns null if estimateFaces returns empty list', () async {
        when(
          () => faceLandmarksDetector.estimateFaces(
            '',
            estimationConfig: any(named: 'estimationConfig'),
          ),
        ).thenAnswer((_) async => List<Face>.empty());

        await expectLater(
          avatarDetectorRepository.detectFace(''),
          completion(isNull),
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
