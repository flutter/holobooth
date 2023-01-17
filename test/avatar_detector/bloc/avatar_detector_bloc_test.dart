import 'dart:typed_data';

import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/avatar_detector/avatar_detector.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class _MockAvatarDetectorRepository extends Mock
    implements AvatarDetectorRepository {}

class _FakeAvatar extends Fake implements Avatar {}

class _FakePlane extends Fake implements Plane {
  @override
  Uint8List get bytes => Uint8List.fromList(List.empty());
}

class _FakeCameraImage extends Fake implements CameraImage {
  @override
  List<Plane> get planes => [_FakePlane()];

  @override
  int get width => 0;

  @override
  int get height => 0;
}

void main() {
  group('AvatarDetectorBloc', () {
    late AvatarDetectorRepository avatarDetectorRepository;

    setUp(() {
      avatarDetectorRepository = _MockAvatarDetectorRepository();
      registerFallbackValue(
        tf.ImageData(bytes: Uint8List(0), size: tf.Size(0, 0)),
      );
    });

    group('AvatarDetectorInitialized', () {
      blocTest<AvatarDetectorBloc, AvatarDetectorState>(
        'emits [AvatarDetectorStatus.loading, AvatarDetectorStatus.loaded] '
        'if preloadLandmarksModel finishes correctly.',
        setUp: () {
          when(
            () => avatarDetectorRepository.preloadLandmarksModel(),
          ).thenAnswer((_) => Future.value());
        },
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) => bloc.add(AvatarDetectorInitialized()),
        expect: () => [
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.loading),
          ),
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.loaded),
          ),
        ],
      );

      blocTest<AvatarDetectorBloc, AvatarDetectorState>(
        'emits [AvatarDetectorStatus.loading, AvatarDetectorStatus.error] '
        'if preloadLandmarksModel throws exception.',
        setUp: () {
          when(
            () => avatarDetectorRepository.preloadLandmarksModel(),
          ).thenThrow(Exception());
        },
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) => bloc.add(AvatarDetectorInitialized()),
        expect: () => [
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.loading),
          ),
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.error),
          ),
        ],
      );
    });

    group('AvatarDetectorEstimateRequested', () {
      late Avatar avatar;

      setUpAll(() {
        registerFallbackValue(_FakeCameraImage());
      });

      setUp(() {
        avatar = _FakeAvatar();

        when(
          () => avatarDetectorRepository.preloadLandmarksModel(),
        ).thenAnswer((_) => Future.value());
      });

      blocTest<AvatarDetectorBloc, AvatarDetectorState>(
        'emits nothing if model is not loaded',
        setUp: () {
          when(
            () => avatarDetectorRepository.detectAvatar(any()),
          ).thenThrow(Exception());
        },
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) => bloc.add(
          AvatarDetectorEstimateRequested(_FakeCameraImage()),
        ),
        expect: () => <AvatarDetectorState>[],
      );

      blocTest<AvatarDetectorBloc, AvatarDetectorState>(
        'emits AvatarDetectorStatus.estimating, AvatarDetectorStatus.error '
        'if detectAvatar throws exception.',
        setUp: () {
          when(
            () => avatarDetectorRepository.detectAvatar(any()),
          ).thenThrow(Exception());
        },
        seed: () => AvatarDetectorState(status: AvatarDetectorStatus.loaded),
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) async {
          bloc.add(AvatarDetectorEstimateRequested(_FakeCameraImage()));
        },
        expect: () => [
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.estimating),
          ),
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.error),
          ),
        ],
      );

      blocTest<AvatarDetectorBloc, AvatarDetectorState>(
        'emits AvatarDetectorStatus.notDetected '
        'if detectAvatar returns null and undetectedDelay elapsed.',
        setUp: () {
          when(
            () => avatarDetectorRepository.detectAvatar(any()),
          ).thenAnswer((_) async => null);
        },
        seed: () => AvatarDetectorState(
          status: AvatarDetectorStatus.estimating,
          lastAvatarDetection: DateTime(1),
        ),
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) async {
          bloc.add(AvatarDetectorEstimateRequested(_FakeCameraImage()));
        },
        expect: () => [
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.notDetected),
          ),
        ],
      );

      blocTest<AvatarDetectorBloc, AvatarDetectorState>(
        'emits '
        'AvatarDetectorStatus.estimating] '
        'if detectAvatar returns null and undetectedDelay not elapsed.',
        setUp: () {
          when(
            () => avatarDetectorRepository.detectAvatar(any()),
          ).thenAnswer((_) async => null);
        },
        seed: () => AvatarDetectorState(
          status: AvatarDetectorStatus.loaded,
          lastAvatarDetection: DateTime.now(),
        ),
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) async {
          bloc.add(AvatarDetectorEstimateRequested(_FakeCameraImage()));
        },
        expect: () => [
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.estimating),
          ),
        ],
      );

      blocTest<AvatarDetectorBloc, AvatarDetectorState>(
        'AvatarDetectorStatus.estimating, AvatarDetectorStatus.warming '
        'if detectAvatar returns avatar but still no 10 avatars.',
        setUp: () {
          when(
            () => avatarDetectorRepository.detectAvatar(any()),
          ).thenAnswer((_) async => avatar);
        },
        seed: () => AvatarDetectorState(
          status: AvatarDetectorStatus.loaded,
          lastAvatarDetection: DateTime.now(),
        ),
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) async {
          bloc.add(AvatarDetectorEstimateRequested(_FakeCameraImage()));
        },
        expect: () => [
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.estimating),
          ),
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.warming),
          ),
        ],
      );

      blocTest<AvatarDetectorBloc, AvatarDetectorState>(
        'emits AvatarDetectorStatus.estimating, '
        'AvatarDetectorStatus.detected] if detectAvatar '
        'returns avatar and already warm up.',
        setUp: () {
          when(
            () => avatarDetectorRepository.detectAvatar(any()),
          ).thenAnswer((_) async => avatar);
        },
        seed: () => AvatarDetectorState(
          status: AvatarDetectorStatus.loaded,
          lastAvatarDetection: DateTime.now(),
          detectedAvatarCount: 10,
        ),
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) async {
          bloc.add(AvatarDetectorEstimateRequested(_FakeCameraImage()));
        },
        expect: () => [
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.estimating),
          ),
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.detected),
          ),
        ],
      );
    });
  });
}
