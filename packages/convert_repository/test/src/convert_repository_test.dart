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
      expect(ConvertRepository(), isNotNull);
    });

    group('convertFrames', () {
      late MultipartRequest multipartRequest;
      late ConvertRepository convertRepository;
      late StreamedResponse streamedResponse;

      setUp(() {
        multipartRequest = _MockMultipartRequest();
        convertRepository = ConvertRepository(
          multipartRequest: multipartRequest,
        );
        streamedResponse = _MockStreamedResponse();

        when(() => multipartRequest.files).thenReturn([]);
        when(() => multipartRequest.send()).thenAnswer(
          (_) async => streamedResponse,
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
          (_) => ByteStream.fromBytes([112, 97, 116, 104]),
        );

        final path = await convertRepository.convertFrames([Uint8List(0)]);

        expect(path, 'path');
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
