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
        'emits [AvatarDetectorLoading, AvatarDetectorLoaded] '
        'if preloadLandmarksModel finishes correctly.',
        setUp: () {
          when(
            () => avatarDetectorRepository.preloadLandmarksModel(),
          ).thenAnswer((_) => Future.value());
        },
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) => bloc.add(AvatarDetectorInitialized()),
        expect: () => [
          AvatarDetectorLoading(),
          AvatarDetectorLoaded(),
        ],
      );

      blocTest<AvatarDetectorBloc, AvatarDetectorState>(
        'emits [AvatarDetectorError, AvatarDetectorLoaded] '
        'if preloadLandmarksModel throws exception.',
        setUp: () {
          when(
            () => avatarDetectorRepository.preloadLandmarksModel(),
          ).thenThrow(Exception());
        },
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) => bloc.add(AvatarDetectorInitialized()),
        expect: () => [
          AvatarDetectorLoading(),
          AvatarDetectorError(),
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
      });

      blocTest<AvatarDetectorBloc, AvatarDetectorState>(
        'emits [AvatarDetectorEstimating, AvatarDetectorNotDetected] '
        'if detectAvatar throws exception.',
        setUp: () {
          when(
            () => avatarDetectorRepository.detectAvatar(any()),
          ).thenThrow(Exception());
        },
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) =>
            bloc.add(AvatarDetectorEstimateRequested(_FakeCameraImage())),
        expect: () => [
          AvatarDetectorEstimating(),
          AvatarDetectorNotDetected(),
        ],
      );

      blocTest<AvatarDetectorBloc, AvatarDetectorState>(
        'emits [AvatarDetectorEstimating, AvatarDetectorNotDetected] '
        'if detectAvatar returns null.',
        setUp: () {
          when(
            () => avatarDetectorRepository.detectAvatar(any()),
          ).thenAnswer((_) async => null);
        },
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) =>
            bloc.add(AvatarDetectorEstimateRequested(_FakeCameraImage())),
        expect: () => [
          AvatarDetectorEstimating(),
          AvatarDetectorNotDetected(),
        ],
      );

      blocTest<AvatarDetectorBloc, AvatarDetectorState>(
        'emits [AvatarDetectorEstimating, AvatarDetectorNotDetected] '
        'if detectAvatar returns null.',
        setUp: () {
          when(
            () => avatarDetectorRepository.detectAvatar(any()),
          ).thenAnswer((_) async => avatar);
        },
        build: () => AvatarDetectorBloc(avatarDetectorRepository),
        act: (bloc) =>
            bloc.add(AvatarDetectorEstimateRequested(_FakeCameraImage())),
        expect: () => [
          AvatarDetectorEstimating(),
          AvatarDetectorDetected(avatar),
        ],
      );
    });
  });
}
