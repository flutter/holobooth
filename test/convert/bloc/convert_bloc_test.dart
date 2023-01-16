import 'dart:typed_data';
import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:download_repository/download_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:mocktail/mocktail.dart';
import 'package:screen_recorder/screen_recorder.dart';

class _MockConvertRepository extends Mock implements ConvertRepository {}

class _MockDownloadRepository extends Mock implements DownloadRepository {}

class _MockImage extends Mock implements Image {}

void main() {
  late ConvertRepository convertRepository;
  late DownloadRepository downloadRepository;

  group('ConvertBloc', () {
    late Image image;
    late List<Frame> frames;
    const totalFrames = 10;

    setUp(() {
      convertRepository = _MockConvertRepository();
      downloadRepository = _MockDownloadRepository();
      image = _MockImage();
      when(() => image.toByteData(format: ImageByteFormat.png))
          .thenAnswer((_) async => ByteData(1));

      frames = List.filled(totalFrames, Frame(Duration.zero, image));
    });

    group('GenerateVideoRequested', () {
      const videoUrl = 'test-video-path';
      const gifUrl = 'test-gif-path';
      final firstFrame = Uint8List(1);

      blocTest<ConvertBloc, ConvertState>(
        'emits [loadingVideo, videoProcessed] with videoPath and gifPath',
        setUp: () {
          when(() => convertRepository.generateVideo(any())).thenAnswer(
            (_) async => GenerateVideoResponse(
              videoUrl: videoUrl,
              gifUrl: gifUrl,
              firstFrame: firstFrame,
            ),
          );
        },
        build: () => ConvertBloc(
          convertRepository: convertRepository,
          downloadRepository: downloadRepository,
        ),
        act: (bloc) => bloc.add(GenerateVideoRequested(frames)),
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
        'emits [creatingVideo, error] if generateVideo fails.',
        setUp: () {
          when(() => convertRepository.generateVideo(any()))
              .thenThrow(Exception());
        },
        build: () => ConvertBloc(
          convertRepository: convertRepository,
          downloadRepository: downloadRepository,
        ),
        act: (bloc) => bloc.add(GenerateVideoRequested(frames)),
        expect: () => [
          ConvertState(),
          ConvertState(
            status: ConvertStatus.error,
          ),
        ],
      );
    });

    group('download', () {
      blocTest<ConvertBloc, ConvertState>(
        'downloads the current converted file',
        setUp: () {
          when(() => downloadRepository.downloadFile(any(), any()))
              .thenAnswer((_) async {});
        },
        seed: () => ConvertState(videoPath: 'https://storage/1234.mp4'),
        build: () => ConvertBloc(
          convertRepository: convertRepository,
          downloadRepository: downloadRepository,
        ),
        act: (bloc) => bloc.download('mp4'),
        verify: (_) {
          verify(
            () => downloadRepository.downloadFile(any(), any()),
          ).called(1);
        },
      );

      blocTest<ConvertBloc, ConvertState>(
        'correctly downloads a mp4',
        setUp: () {
          when(() => downloadRepository.downloadFile(any(), any()))
              .thenAnswer((_) async {});
        },
        seed: () => ConvertState(videoPath: 'https://storage/1234.mp4'),
        build: () => ConvertBloc(
          convertRepository: convertRepository,
          downloadRepository: downloadRepository,
        ),
        act: (bloc) => bloc.download('mp4'),
        verify: (_) {
          verify(
            () => downloadRepository.downloadFile('1234.mp4', 'video/mp4'),
          ).called(1);
        },
      );

      blocTest<ConvertBloc, ConvertState>(
        'correctly downloads a gif',
        setUp: () {
          when(() => downloadRepository.downloadFile(any(), any()))
              .thenAnswer((_) async {});
        },
        seed: () => ConvertState(videoPath: 'https://storage/1234.mp4'),
        build: () => ConvertBloc(
          convertRepository: convertRepository,
          downloadRepository: downloadRepository,
        ),
        act: (bloc) => bloc.download('gif'),
        verify: (_) {
          verify(
            () => downloadRepository.downloadFile('1234.gif', 'image/gif'),
          ).called(1);
        },
      );
    });
  });
}
