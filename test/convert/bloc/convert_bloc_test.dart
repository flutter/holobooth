import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:mocktail/mocktail.dart';
import 'package:screen_recorder/screen_recorder.dart';

class _MockConvertRepository extends Mock implements ConvertRepository {}

void main() {
  late ConvertRepository convertRepository;

  group('ConvertBloc', () {
    group('ConvertFrames', () {
      final frames = [RawFrame(0, ByteData(0))];

      blocTest<ConvertBloc, ConvertState>(
        'return video path for request',
        setUp: () {
          convertRepository = _MockConvertRepository();
          when(() => convertRepository.convertFrames(any())).thenAnswer(
            (_) async => ConvertResponse(
              videoUrl: 'test-video-path',
              gifUrl: 'test-gif-path',
            ),
          );
        },
        build: () => ConvertBloc(convertRepository: convertRepository),
        act: (bloc) => bloc.add(
          ConvertFrames(frames),
        ),
        expect: () => [
          ConvertState(
            frames: frames,
            status: ConvertStatus.loading,
          ),
          ConvertState(
            frames: frames,
            videoPath: 'test-video-path',
            gifPath: 'test-gif-path',
            status: ConvertStatus.success,
          ),
        ],
      );

      blocTest<ConvertBloc, ConvertState>(
        'return error status on error',
        setUp: () {
          convertRepository = _MockConvertRepository();
          when(() => convertRepository.convertFrames(any()))
              .thenThrow(Exception());
        },
        build: () => ConvertBloc(convertRepository: convertRepository),
        act: (bloc) => bloc.add(
          ConvertFrames(frames),
        ),
        expect: () => [
          ConvertState(
            frames: frames,
            status: ConvertStatus.loading,
          ),
          ConvertState(
            frames: frames,
            status: ConvertStatus.error,
          ),
        ],
      );

      blocTest<ConvertBloc, ConvertState>(
        'return finished state on FinishConvert event',
        setUp: () {
          convertRepository = _MockConvertRepository();
        },
        build: () => ConvertBloc(convertRepository: convertRepository),
        act: (bloc) => bloc.add(FinishConvert()),
        expect: () => [
          isA<ConvertState>().having(
            (state) => state.isFinished,
            'isFinished',
            true,
          ),
        ],
      );
    });
  });
}
