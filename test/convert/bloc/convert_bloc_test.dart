import 'dart:typed_data';
import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:mocktail/mocktail.dart';
import 'package:screen_recorder/screen_recorder.dart';

class _MockConvertRepository extends Mock implements ConvertRepository {}

class _MockImage extends Mock implements Image {}

void main() {
  group('ConvertBloc', () {
    late ConvertRepository convertRepository;
    late Image image;
    late List<Frame> frames;
    const totalFrames = 10;

    setUp(() {
      convertRepository = _MockConvertRepository();
      image = _MockImage();
      when(() => image.toByteData(format: ImageByteFormat.png))
          .thenAnswer((_) async => ByteData(1));

      frames = List.filled(totalFrames, Frame(Duration.zero, image));
    });

    group('GenerateFramesRequested', () {
      blocTest<ConvertBloc, ConvertState>(
        'emits ConvertStatus.loadingFrames, and '
        'ConvertStatus.errorLoadingFrames if processFrames fails',
        setUp: () {
          when(() => convertRepository.processFrames(any()))
              .thenThrow(Exception());
        },
        build: () => ConvertBloc(
          convertRepository: convertRepository,
          frames: frames,
        ),
        act: (bloc) => bloc.add(GenerateFramesRequested()),
        expect: () => [
          ConvertState(),
          ConvertState(status: ConvertStatus.errorLoadingFrames, triesCount: 1),
        ],
      );

      blocTest<ConvertBloc, ConvertState>(
        'emits ConvertStatus.loadingFrames, and '
        'ConvertStatus.loadedFrames if processFrames return frames.',
        setUp: () {
          when(() => convertRepository.processFrames(any()))
              .thenAnswer((invocation) async => [Uint8List(1)]);
        },
        build: () => ConvertBloc(
          convertRepository: convertRepository,
          frames: frames,
        ),
        act: (bloc) => bloc.add(GenerateFramesRequested()),
        expect: () => [
          ConvertState(),
          ConvertState(
            status: ConvertStatus.loadedFrames,
            firstFrameProcessed: Uint8List(1),
          ),
        ],
      );
    });

    group('GenerateVideoRequested', () {
      const videoUrl = 'test-video-path';
      const gifUrl = 'test-gif-path';
      final firstFrame = Uint8List(1);

      blocTest<ConvertBloc, ConvertState>(
        'emits nothing if maxTriesReached ',
        seed: () => ConvertState(triesCount: 3),
        build: () => ConvertBloc(
          convertRepository: convertRepository,
          frames: frames,
        ),
        act: (bloc) => bloc.add(GenerateVideoRequested()),
        expect: () => <ConvertState>[],
      );

      blocTest<ConvertBloc, ConvertState>(
        'emits [creatingVideo, error] if generateVideo fails.',
        setUp: () {
          when(() => convertRepository.generateVideo()).thenThrow(Exception());
        },
        build: () => ConvertBloc(
          convertRepository: convertRepository,
          frames: frames,
        ),
        act: (bloc) => bloc.add(GenerateVideoRequested()),
        expect: () => [
          ConvertState(status: ConvertStatus.creatingVideo),
          ConvertState(
            status: ConvertStatus.errorGeneratingVideo,
            triesCount: 1,
          ),
        ],
      );

      blocTest<ConvertBloc, ConvertState>(
        'emits [creatingVideo, videoCreated] '
        'with videoPath and gifPath',
        setUp: () {
          when(() => convertRepository.generateVideo()).thenAnswer(
            (_) async => GenerateVideoResponse(
              videoUrl: videoUrl,
              gifUrl: gifUrl,
              firstFrame: firstFrame,
              twitterShareUrl: 'twitter',
              facebookShareUrl: 'facebook',
            ),
          );
        },
        build: () => ConvertBloc(
          convertRepository: convertRepository,
          frames: frames,
        ),
        act: (bloc) => bloc.add(GenerateVideoRequested()),
        expect: () => [
          ConvertState(status: ConvertStatus.creatingVideo),
          ConvertState(
            status: ConvertStatus.videoCreated,
            gifPath: gifUrl,
            videoPath: videoUrl,
            twitterShareUrl: 'twitter',
            facebookShareUrl: 'facebook',
          ),
        ],
      );

      blocTest<ConvertBloc, ConvertState>(
        'emits [creatingVideo, videoCreated] '
        'with videoPath and gifPath and updating shareStatus '
        'to ShareStatus.ready if previous was  ShareStatus.waiting',
        setUp: () {
          when(() => convertRepository.generateVideo()).thenAnswer(
            (_) async => GenerateVideoResponse(
              videoUrl: videoUrl,
              gifUrl: gifUrl,
              firstFrame: firstFrame,
            ),
          );
        },
        seed: () => ConvertState(shareStatus: ShareStatus.waiting),
        build: () => ConvertBloc(
          convertRepository: convertRepository,
          frames: frames,
        ),
        act: (bloc) => bloc.add(GenerateVideoRequested()),
        expect: () => [
          ConvertState(
            status: ConvertStatus.creatingVideo,
            shareStatus: ShareStatus.waiting,
          ),
          ConvertState(
            status: ConvertStatus.videoCreated,
            gifPath: gifUrl,
            videoPath: videoUrl,
            shareStatus: ShareStatus.ready,
          ),
        ],
      );

      blocTest<ConvertBloc, ConvertState>(
        'emit error state until maxTriesReached if generateVideo fails.',
        setUp: () {
          when(() => convertRepository.generateVideo()).thenThrow(Exception());
        },
        build: () => ConvertBloc(
          convertRepository: convertRepository,
          frames: frames,
        ),
        act: (bloc) {
          for (var i = 0; i < 3; i++) {
            bloc.add(GenerateVideoRequested());
          }
        },
        expect: () => <ConvertState>[
          ConvertState(status: ConvertStatus.creatingVideo),
          ConvertState(
            status: ConvertStatus.errorGeneratingVideo,
            triesCount: 1,
          ),
          ConvertState(triesCount: 1, status: ConvertStatus.creatingVideo),
          ConvertState(
            status: ConvertStatus.errorGeneratingVideo,
            triesCount: 2,
          ),
          ConvertState(triesCount: 2, status: ConvertStatus.creatingVideo),
          ConvertState(
            status: ConvertStatus.errorGeneratingVideo,
            triesCount: 3,
          ),
        ],
      );
    });

    group('ShareRequested', () {
      blocTest<ConvertBloc, ConvertState>(
        'emits ShareStatus.waiting and shareType if '
        'ConvertStatus.creatingVideo',
        seed: () => ConvertState(
          status: ConvertStatus.creatingVideo,
        ),
        build: () => ConvertBloc(
          convertRepository: convertRepository,
          frames: frames,
        ),
        act: (bloc) => bloc.add(ShareRequested(ShareType.download)),
        expect: () => const <ConvertState>[
          ConvertState(
            status: ConvertStatus.creatingVideo,
            shareStatus: ShareStatus.waiting,
            shareType: ShareType.download,
          ),
        ],
      );
    });
  });
}
