import 'dart:typed_data';
import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/convert/convert.dart';
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

    setUp(() {
      convertRepository = _MockConvertRepository();
      image = _MockImage();
      when(() => image.toByteData(format: ImageByteFormat.png))
          .thenAnswer((_) async => ByteData(1));

      frames = List.filled(totalFrames, Frame(Duration.zero, image));
    });

    group('ConvertFrames', () {
      blocTest<ConvertBloc, ConvertState>(
        'emits [loadingFrames, progress, framesProcessed] with processedFrames',
        build: () => ConvertBloc(convertRepository: convertRepository),
        act: (bloc) => bloc.add(ConvertFrames(frames)),
        wait: Duration(milliseconds: 300),
        expect: () => [
          ConvertState(),
          ConvertState(progress: 0.5),
          ConvertState(progress: 1),
          ConvertState(
            progress: 1,
            status: ConvertStatus.framesProcessed,
            firstFrameProcessed: List.filled(totalFrames, Uint8List(1)),
          ),
        ],
      );

      blocTest<ConvertBloc, ConvertState>(
        'emits [loadingFrames, error] if toByteData fails',
        setUp: () {
          when(() => image.toByteData(format: ImageByteFormat.png))
              .thenThrow(Exception());
        },
        build: () => ConvertBloc(convertRepository: convertRepository),
        act: (bloc) => bloc.add(ConvertFrames(frames)),
        expect: () => [
          ConvertState(),
          ConvertState(status: ConvertStatus.error),
        ],
      );
    });

    group('GenerateVideo', () {
      const videoUrl = 'test-video-path';
      const gifUrl = 'test-gif-path';
      final processedFrames = List.filled(10, Uint8List(1));

      blocTest<ConvertBloc, ConvertState>(
        'emits [loadingVideo, videoProcessed] with videoPath and gifPath',
        setUp: () {
          when(() => convertRepository.generateVideo(any())).thenAnswer(
            (_) async => ConvertResponse(
              videoUrl: videoUrl,
              gifUrl: gifUrl,
            ),
          );
        },
        seed: () => ConvertState(firstFrameProcessed: processedFrames),
        build: () => ConvertBloc(convertRepository: convertRepository),
        act: (bloc) => bloc.add(GenerateVideo()),
        expect: () => [
          ConvertState(
            status: ConvertStatus.creatingVideo,
            firstFrameProcessed: processedFrames,
          ),
          ConvertState(
            status: ConvertStatus.videoCreated,
            firstFrameProcessed: processedFrames,
            gifPath: gifUrl,
            videoPath: videoUrl,
          ),
        ],
      );

      blocTest<ConvertBloc, ConvertState>(
        'emits [loadingVideo, error] if convertFrames fails.',
        setUp: () {
          when(() => convertRepository.generateVideo(any()))
              .thenThrow(Exception());
        },
        seed: () => ConvertState(firstFrameProcessed: processedFrames),
        build: () => ConvertBloc(convertRepository: convertRepository),
        act: (bloc) => bloc.add(GenerateVideo()),
        expect: () => [
          ConvertState(
            status: ConvertStatus.creatingVideo,
            firstFrameProcessed: processedFrames,
          ),
          ConvertState(
            status: ConvertStatus.error,
            firstFrameProcessed: processedFrames,
          ),
        ],
      );
    });
  });
}
