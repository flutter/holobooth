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
  late ConvertRepository convertRepository;

  group('ConvertBloc', () {
    late Image image;
    late List<Frame> frames;
    const totalFrames = 10;
    late List<Image> framesAsImages;

    setUp(() {
      convertRepository = _MockConvertRepository();
      image = _MockImage();
      when(() => image.toByteData(format: ImageByteFormat.png))
          .thenAnswer((_) async => ByteData(1));

      frames = List.filled(totalFrames, Frame(Duration.zero, image));
      framesAsImages = frames.map((e) => e.image).toList();
    });

    group('GenerateVideoRequested', () {
      const videoUrl = 'test-video-path';
      const gifUrl = 'test-gif-path';
      final firstFrame = Uint8List(1);

      blocTest<ConvertBloc, ConvertState>(
        'emits [creatingVideo, creatingVideo, videoCreated] with frames, '
        'videoPath and gifPath',
        setUp: () {
          when(() => convertRepository.generateVideo(any())).thenAnswer(
            (_) async => GenerateVideoResponse(
              videoUrl: videoUrl,
              gifUrl: gifUrl,
              firstFrame: firstFrame,
            ),
          );
        },
        build: () => ConvertBloc(convertRepository: convertRepository),
        act: (bloc) => bloc.add(GenerateVideoRequested(frames: frames)),
        expect: () => [
          ConvertState(),
          ConvertState(frames: framesAsImages),
          ConvertState(
            status: ConvertStatus.videoCreated,
            gifPath: gifUrl,
            videoPath: videoUrl,
            firstFrameProcessed: firstFrame,
            frames: framesAsImages,
          ),
        ],
      );

      blocTest<ConvertBloc, ConvertState>(
        'emits [creatingVideo, error] if generateVideo fails.',
        setUp: () {
          when(() => convertRepository.generateVideo(any()))
              .thenThrow(Exception());
        },
        build: () => ConvertBloc(convertRepository: convertRepository),
        act: (bloc) => bloc.add(GenerateVideoRequested(frames: frames)),
        expect: () => [
          ConvertState(),
          ConvertState(frames: framesAsImages),
          ConvertState(status: ConvertStatus.error, frames: framesAsImages),
        ],
      );

      blocTest<ConvertBloc, ConvertState>(
        'emits [creatingVideo, videoCreated] with videoPath and gifPath '
        'if frames already in the state and no frames passed on the event',
        setUp: () {
          when(() => convertRepository.generateVideo(any())).thenAnswer(
            (_) async => GenerateVideoResponse(
              videoUrl: videoUrl,
              gifUrl: gifUrl,
              firstFrame: firstFrame,
            ),
          );
        },
        seed: () => ConvertState(
          frames: framesAsImages,
          status: ConvertStatus.error,
        ),
        build: () => ConvertBloc(convertRepository: convertRepository),
        act: (bloc) => bloc.add(GenerateVideoRequested()),
        expect: () => [
          ConvertState(frames: framesAsImages),
          ConvertState(
            status: ConvertStatus.videoCreated,
            gifPath: gifUrl,
            videoPath: videoUrl,
            firstFrameProcessed: firstFrame,
            frames: framesAsImages,
          ),
        ],
      );

      blocTest<ConvertBloc, ConvertState>(
        'emit error state until maxTriesReached if generateVideo fails.',
        setUp: () {
          when(() => convertRepository.generateVideo(any()))
              .thenThrow(Exception());
        },
        build: () => ConvertBloc(convertRepository: convertRepository),
        act: (bloc) {
          for (var i = 0; i < 3; i++) {
            bloc.add(GenerateVideoRequested(frames: frames));
          }
        },
        expect: () => <ConvertState>[
          ConvertState(),
          ConvertState(frames: framesAsImages),
          ConvertState(
            status: ConvertStatus.error,
            frames: framesAsImages,
            triesCount: 1,
          ),
          ConvertState(
            frames: framesAsImages,
            triesCount: 1,
          ),
          ConvertState(
            status: ConvertStatus.error,
            frames: framesAsImages,
            triesCount: 2,
          ),
          ConvertState(
            frames: framesAsImages,
            triesCount: 2,
          ),
          ConvertState(
            status: ConvertStatus.error,
            frames: framesAsImages,
            triesCount: 3,
          ),
        ],
      );
    });
  });
}
