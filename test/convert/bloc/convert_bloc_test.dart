import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:mocktail/mocktail.dart';
import 'package:screen_recorder/screen_recorder.dart';

class _MockConvertRepository extends Mock implements ConvertRepository {}

class _FakeImage extends Fake implements Image {}

void main() {
  late ConvertRepository convertRepository;

  group('ConvertBloc', () {
    group('ConvertFrames', () {
      final frames = [Frame(Duration.zero, _FakeImage())];

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
            status: ConvertStatus.loadingFrames,
          ),
          ConvertState(
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
            status: ConvertStatus.loadingFrames,
          ),
          ConvertState(
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
