// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:collection';

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

class _FakeKeypoint extends Fake implements Keypoint {
  _FakeKeypoint(this.x, this.y, this.z);

  @override
  final double x;

  @override
  final double y;

  @override
  final double? z;
}

class _FakeFace extends Fake implements Face {
  @override
  UnmodifiableListView<Keypoint> get keypoints => UnmodifiableListView(
        List.generate(357, (_) => _FakeKeypoint(0, 0, 0)),
      );

  @override
  BoundingBox get boundingBox => const BoundingBox(10, 10, 110, 110, 100, 100);
}

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

    group('detectAvatar', () {
      test(
          'calls preloadLandmarksModel if '
          'faceLandmarksDetector is not initialized yet', () async {
        when(
          () => faceLandmarksDetector.estimateFaces(
            '',
            estimationConfig: any(named: 'estimationConfig'),
          ),
        ).thenAnswer((_) async => <Face>[_FakeFace()]);
        await avatarDetectorRepository.detectAvatar('');
        verify(() => tensorflowModelsPlatform.loadFaceLandmark()).called(1);
      });

      test('throws DetectAvatarException if estimateFaces fails', () {
        when(
          () => faceLandmarksDetector.estimateFaces(
            '',
            estimationConfig: any(named: 'estimationConfig'),
          ),
        ).thenThrow(Exception());
        expect(
          avatarDetectorRepository.detectAvatar(''),
          throwsA(isA<DetectAvatarException>()),
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
          avatarDetectorRepository.detectAvatar(''),
          completion(isNull),
        );
      });

      test('return an Avatar', () async {
        when(
          () => faceLandmarksDetector.estimateFaces(
            '',
            estimationConfig: any(named: 'estimationConfig'),
          ),
        ).thenAnswer((_) async => <Face>[_FakeFace()]);
        await expectLater(
          avatarDetectorRepository.detectAvatar(''),
          completion(isA<Avatar>()),
        );
      });

      test('return an Avatar when called multiple times', () async {
        when(
          () => faceLandmarksDetector.estimateFaces(
            '',
            estimationConfig: any(named: 'estimationConfig'),
          ),
        ).thenAnswer((_) async => <Face>[_FakeFace()]);

        await expectLater(
          avatarDetectorRepository.detectAvatar(''),
          completion(isA<Avatar>()),
        );
        await expectLater(
          avatarDetectorRepository.detectAvatar(''),
          completion(isA<Avatar>()),
        );
      });
    });

    group('dispose', () {
      test('calls to dispose', () async {
        await avatarDetectorRepository.preloadLandmarksModel();
        avatarDetectorRepository.dispose();
        verify(() => faceLandmarksDetector.dispose()).called(1);
      });
    });
  });
}
