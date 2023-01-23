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
          when(
            () => downloadRepository.downloadFile(
              fileName: any(named: 'fileName'),
              fileId: any(named: 'fileId'),
              mimeType: any(named: 'mimeType'),
            ),
          ).thenAnswer((_) async {});
        },
        build: () => DownloadBloc(
          downloadRepository: downloadRepository,
        ),
        act: (bloc) =>
            bloc.add(DownloadRequested('mp4', 'https://storage/1234.mp4')),
        verify: (_) {
          verify(
            () => downloadRepository.downloadFile(
              fileName: any(named: 'fileName'),
              fileId: any(named: 'fileId'),
              mimeType: any(named: 'mimeType'),
            ),
          ).called(1);
        },
      );

      blocTest<DownloadBloc, DownloadState>(
        'correctly downloads a mp4',
        setUp: () {
          when(
            () => downloadRepository.downloadFile(
              fileName: any(named: 'fileName'),
              fileId: any(named: 'fileId'),
              mimeType: any(named: 'mimeType'),
            ),
          ).thenAnswer((_) async {});
        },
        build: () => DownloadBloc(
          downloadRepository: downloadRepository,
        ),
        act: (bloc) =>
            bloc.add(DownloadRequested('mp4', 'https://storage/1234.mp4')),
        verify: (_) {
          verify(
            () => downloadRepository.downloadFile(
              fileId: '1234.mp4',
              fileName: 'flutter_holobooth.mp4',
              mimeType: 'video/mp4',
            ),
          ).called(1);
        },
      );

      blocTest<DownloadBloc, DownloadState>(
        'correctly downloads a gif',
        setUp: () {
          when(
            () => downloadRepository.downloadFile(
              fileName: any(named: 'fileName'),
              fileId: any(named: 'fileId'),
              mimeType: any(named: 'mimeType'),
            ),
          ).thenAnswer((_) async {});
        },
        build: () => DownloadBloc(
          downloadRepository: downloadRepository,
        ),
        act: (bloc) =>
            bloc.add(DownloadRequested('gif', 'https://storage/1234.gif')),
        verify: (_) {
          verify(
            () => downloadRepository.downloadFile(
              fileId: '1234.gif',
              fileName: 'flutter_holobooth.gif',
              mimeType: 'image/gif',
            ),
          ).called(1);
        },
      );
    });
  });
}
