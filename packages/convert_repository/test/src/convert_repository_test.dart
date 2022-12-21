// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:convert_repository/convert_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class _MockMultipartRequest extends Mock implements MultipartRequest {}

class _MockStreamedResponse extends Mock implements StreamedResponse {}

void main() {
  group('ConvertRepository', () {
    test('can be instantiated', () {
      expect(ConvertRepository(url: ''), isNotNull);
    });

    group('convertFrames', () {
      late MultipartRequest multipartRequest;
      late ConvertRepository convertRepository;
      late StreamedResponse streamedResponse;

      setUp(() {
        multipartRequest = _MockMultipartRequest();
        convertRepository = ConvertRepository(
          multipartRequestBuilder: () => multipartRequest,
          url: '',
        );
        streamedResponse = _MockStreamedResponse();

        when(() => multipartRequest.files).thenReturn([]);
        when(multipartRequest.send).thenAnswer(
          (_) async => streamedResponse,
        );
      });

      test('throws ConvertException with empty url', () async {
        final convertRepository = ConvertRepository(url: '');
        await expectLater(
          () async => convertRepository.convertFrames([Uint8List(0)]),
          throwsA(isA<ConvertException>()),
        );
      });

      test('throws ConvertException on empty frames', () async {
        await expectLater(
          () async => convertRepository.convertFrames([]),
          throwsA(isA<ConvertException>()),
        );
      });

      test('return value on success', () async {
        when(() => streamedResponse.statusCode).thenReturn(200);
        when(() => streamedResponse.stream).thenAnswer(
          (_) => ByteStream.fromBytes(
            '{"video_url": "video", "gif_url": "gif"}'.codeUnits,
          ),
        );

        final response = await convertRepository.convertFrames([Uint8List(0)]);

        expect(response.videoUrl, equals('video'));
        expect(response.gifUrl, equals('gif'));
      });

      test('throws on status code different than 200', () async {
        when(() => streamedResponse.statusCode).thenReturn(1);

        await expectLater(
          () async => convertRepository.convertFrames([Uint8List(0)]),
          throwsA(isA<ConvertException>()),
        );
      });
    });
  });
}
