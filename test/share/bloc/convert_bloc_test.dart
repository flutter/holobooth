import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:screen_recorder/screen_recorder.dart';

class _MockConvertRepository extends Mock implements ConvertRepository {}

void main() {
  late ConvertRepository convertRepository;

  group('ConvertBloc', () {
    blocTest<ConvertBloc, ConvertState>(
      'return video path for request',
      setUp: () {
        convertRepository = _MockConvertRepository();
        when(() => convertRepository.convertFrames(any()))
            .thenAnswer((_) async => 'test-video-path');
      },
      build: () => ConvertBloc(convertRepository: convertRepository),
      act: (bloc) => bloc.add(
        ConvertFrames(
          [
            RawFrame(0, ByteData(0)),
          ],
        ),
      ),
      expect: () => [
        ConvertLoading(),
        ConvertSuccess('test-video-path'),
      ],
    );

    blocTest<ConvertBloc, ConvertState>(
      'return ConvertError state on error',
      setUp: () {
        convertRepository = _MockConvertRepository();
        when(() => convertRepository.convertFrames(any()))
            .thenThrow(Exception());
      },
      build: () => ConvertBloc(convertRepository: convertRepository),
      act: (bloc) => bloc.add(ConvertFrames(const [])),
      expect: () => [
        ConvertLoading(),
        ConvertError(),
      ],
    );
  });
}
