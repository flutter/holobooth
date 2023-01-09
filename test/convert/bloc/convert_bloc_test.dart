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

    group('GenerateVideo', () {
      const videoUrl = 'test-video-path';
      const gifUrl = 'test-gif-path';
      final firstFrame = Uint8List(1);

      blocTest<ConvertBloc, ConvertState>(
        'emits [loadingVideo, videoProcessed] with videoPath and gifPath',
        setUp: () {
          when(() => convertRepository.generateVideo(any())).thenAnswer(
            (_) async => ConvertResponse(
              videoUrl: videoUrl,
              gifUrl: gifUrl,
              firstFrame: firstFrame,
            ),
          );
        },
        build: () => ConvertBloc(convertRepository: convertRepository),
        act: (bloc) => bloc.add(GenerateVideo(frames)),
        expect: () => [
          ConvertState(),
          ConvertState(
            status: ConvertStatus.videoCreated,
            gifPath: gifUrl,
            videoPath: videoUrl,
            firstFrameProcessed: firstFrame,
          ),
        ],
      );

      blocTest<ConvertBloc, ConvertState>(
        'emits [creatingVideo, error] if GenerateVideo fails.',
        setUp: () {
          when(() => convertRepository.generateVideo(any()))
              .thenThrow(Exception());
        },
        build: () => ConvertBloc(convertRepository: convertRepository),
        act: (bloc) => bloc.add(GenerateVideo(frames)),
        expect: () => [
          ConvertState(),
          ConvertState(
            status: ConvertStatus.error,
          ),
        ],
      );
    });
  });
}
