import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:mocktail/mocktail.dart';

class _MockAvatarDetectorRepository extends Mock
    implements AvatarDetectorRepository {}

void main() {
  group('AvatarDetectorBloc', () {
    late AvatarDetectorRepository avatarDetectorRepository;
    setUp(() {
      avatarDetectorRepository = _MockAvatarDetectorRepository();
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
        expect: () =>
            [isA<AvatarDetectorLoading>(), isA<AvatarDetectorLoaded>()],
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
        expect: () =>
            [isA<AvatarDetectorLoading>(), isA<AvatarDetectorError>()],
      );
    });
  });
}
