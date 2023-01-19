import 'package:bloc_test/bloc_test.dart';
import 'package:download_repository/download_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

class _MockDownloadRepository extends Mock implements DownloadRepository {}

void main() {
  late DownloadRepository downloadRepository;

  group('DownloadBloc', () {
    setUp(() {
      downloadRepository = _MockDownloadRepository();
    });

    group('download', () {
      blocTest<DownloadBloc, DownloadState>(
        'downloads the current converted file',
        setUp: () {
          when(() => downloadRepository.downloadFile(any(), any()))
              .thenAnswer((_) async {});
        },
        build: () => DownloadBloc(
          downloadRepository: downloadRepository,
        ),
        act: (bloc) =>
            bloc.add(DownloadRequested('mp4', 'https://storage/1234.mp4')),
        verify: (_) {
          verify(
            () => downloadRepository.downloadFile(any(), any()),
          ).called(1);
        },
      );

      blocTest<DownloadBloc, DownloadState>(
        'correctly downloads a mp4',
        setUp: () {
          when(() => downloadRepository.downloadFile(any(), any()))
              .thenAnswer((_) async {});
        },
        build: () => DownloadBloc(
          downloadRepository: downloadRepository,
        ),
        act: (bloc) =>
            bloc.add(DownloadRequested('mp4', 'https://storage/1234.mp4')),
        verify: (_) {
          verify(
            () => downloadRepository.downloadFile('1234.mp4', 'video/mp4'),
          ).called(1);
        },
      );

      blocTest<DownloadBloc, DownloadState>(
        'correctly downloads a gif',
        setUp: () {
          when(() => downloadRepository.downloadFile(any(), any()))
              .thenAnswer((_) async {});
        },
        build: () => DownloadBloc(
          downloadRepository: downloadRepository,
        ),
        act: (bloc) =>
            bloc.add(DownloadRequested('gif', 'https://storage/1234.mp4')),
        verify: (_) {
          verify(
            () => downloadRepository.downloadFile('1234.gif', 'image/gif'),
          ).called(1);
        },
      );
    });
  });
}
