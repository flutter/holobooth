import 'dart:typed_data';

import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
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
        'emits [AvatarDetectorStatus.loading, AvatarDetectorStatus.loaded, '
        'AvatarDetectorStatus.estimating, AvatarDetectorStatus.error] '
        'if detectAvatar throws exception.',
        setUp: () {
          when(
            () => avatarDetectorRepository.detectAvatar(any()),
          ).thenThrow(Exception());
        },
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) async {
          bloc
            ..add(AvatarDetectorInitialized())
            ..add(AvatarDetectorEstimateRequested(_FakeCameraImage()));
        },
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
        'emits [AvatarDetectorStatus.loading, AvatarDetectorStatus.loaded, '
        'AvatarDetectorStatus.estimating, AvatarDetectorStatus.notDetected] '
        'if detectAvatar returns null and undetectedDelay elapsed.',
        setUp: () {
          when(
            () => avatarDetectorRepository.detectAvatar(any()),
          ).thenAnswer((_) async => null);
        },
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) async {
          bloc.add(AvatarDetectorInitialized());
          await Future<void>.delayed(AvatarDetectorBloc.undetectedDelay);
          bloc.add(AvatarDetectorEstimateRequested(_FakeCameraImage()));
        },
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
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.estimating),
          ),
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.notDetected),
          ),
        ],
      );

      blocTest<AvatarDetectorBloc, AvatarDetectorState>(
        'emits [AvatarDetectorStatus.loading, AvatarDetectorStatus.loaded, '
        'AvatarDetectorStatus.estimating] '
        'if detectAvatar returns null and undetectedDelay not elapsed.',
        setUp: () {
          when(
            () => avatarDetectorRepository.detectAvatar(any()),
          ).thenAnswer((_) async => null);
        },
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) async {
          bloc
            ..add(AvatarDetectorInitialized())
            ..add(AvatarDetectorEstimateRequested(_FakeCameraImage()));
        },
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
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.estimating),
          ),
        ],
      );

      blocTest<AvatarDetectorBloc, AvatarDetectorState>(
        'emits [AvatarDetectorStatus.loading, AvatarDetectorStatus.loaded, '
        'AvatarDetectorStatus.estimating, AvatarDetectorStatus.warming] '
        'if detectAvatar returns null.',
        setUp: () {
          when(
            () => avatarDetectorRepository.detectAvatar(any()),
          ).thenAnswer((_) async => avatar);
        },
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) async {
          bloc
            ..add(AvatarDetectorInitialized())
            ..add(AvatarDetectorEstimateRequested(_FakeCameraImage()));
        },
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
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.estimating),
          ),
          AvatarDetectorState(
            status: AvatarDetectorStatus.warming,
            avatar: avatar,
          ),
        ],
      );

      blocTest<AvatarDetectorBloc, AvatarDetectorState>(
        'emits [AvatarDetectorStatus.loading, AvatarDetectorStatus.loaded, '
        'AvatarDetectorStatus.estimating, AvatarDetectorStatus.warming, '
        'AvatarDetectorStatus.detected] if detectAvatar returns null.',
        setUp: () {
          when(
            () => avatarDetectorRepository.detectAvatar(any()),
          ).thenAnswer((_) async => avatar);
        },
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) async {
          bloc.add(AvatarDetectorInitialized());

          for (var i = 0; i <= AvatarDetectorBloc.warmingUpImages; i++) {
            await Future<void>.delayed(Duration.zero);
            bloc.add(AvatarDetectorEstimateRequested(_FakeCameraImage()));
          }
        },
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
          for (var i = 0; i < AvatarDetectorBloc.warmingUpImages; i++) ...[
            isInstanceOf<AvatarDetectorState>().having(
              (state) => state.status,
              'status',
              equals(AvatarDetectorStatus.estimating),
            ),
            AvatarDetectorState(
              status: AvatarDetectorStatus.warming,
              avatar: avatar,
            ),
          ],
          isInstanceOf<AvatarDetectorState>().having(
            (state) => state.status,
            'status',
            equals(AvatarDetectorStatus.estimating),
          ),
          AvatarDetectorState(
            status: AvatarDetectorStatus.detected,
            avatar: avatar,
          ),
        ],
      );
    });
  });
}
