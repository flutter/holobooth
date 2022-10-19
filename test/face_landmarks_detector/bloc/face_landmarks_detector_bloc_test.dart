import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/face_landmarks_detector/face_landmarks_detector.dart';
import 'package:mocktail/mocktail.dart';

class _MockAvatarDetectorRepository extends Mock
    implements AvatarDetectorRepository {}

void main() {
  group('FaceLandmarksDetectorBloc', () {
    late AvatarDetectorRepository avatarDetectorRepository;
    setUp(() {
      avatarDetectorRepository = _MockAvatarDetectorRepository();
    });

    group('FaceLandmarksDetectorInitialized', () {
      blocTest<FaceLandmarksDetectorBloc, FaceLandmarksDetectorState>(
        'emits [FaceLandmarksDetectorLoading, FaceLandmarksDetectorLoaded] '
        'if preloadLandmarksModel finishes correctly.',
        setUp: () {
          when(
            () => avatarDetectorRepository.preloadLandmarksModel(),
          ).thenAnswer((_) => Future.value());
        },
        build: () => FaceLandmarksDetectorBloc(avatarDetectorRepository),
        act: (bloc) => bloc.add(FaceLandmarksDetectorInitialized()),
        expect: () => [
          isA<FaceLandmarksDetectorLoading>(),
          isA<FaceLandmarksDetectorLoaded>()
        ],
      );

      blocTest<FaceLandmarksDetectorBloc, FaceLandmarksDetectorState>(
        'emits [FaceLandmarksDetectorError, FaceLandmarksDetectorLoaded] '
        'if preloadLandmarksModel throws exception.',
        setUp: () {
          when(
            () => avatarDetectorRepository.preloadLandmarksModel(),
          ).thenThrow(Exception());
        },
        build: () => FaceLandmarksDetectorBloc(avatarDetectorRepository),
        act: (bloc) => bloc.add(FaceLandmarksDetectorInitialized()),
        expect: () => [
          isA<FaceLandmarksDetectorLoading>(),
          isA<FaceLandmarksDetectorError>()
        ],
      );
    });
  });
}
