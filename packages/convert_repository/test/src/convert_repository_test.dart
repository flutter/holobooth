import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:convert_repository/convert_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:screen_recorder/screen_recorder.dart';

class _MockImage extends Mock implements ui.Image {}

class _MockMultipartRequest extends Mock implements MultipartRequest {}

class _MockStreamedResponse extends Mock implements StreamedResponse {}

void main() {
  group('ConvertRepository', () {
    late MultipartRequest multipartRequest;
    late ConvertRepository convertRepository;
    late StreamedResponse streamedResponse;
    late ui.Image image;
    late List<Frame> frames;

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

      image = _MockImage();
      when(() => image.toByteData(format: ui.ImageByteFormat.png))
          .thenAnswer((_) async => ByteData(1));
      frames = [
        Frame(Duration.zero, image),
        Frame(Duration.zero, image),
      ];
    });

    test('can be instantiated', () {
      expect(ConvertRepository(url: ''), isNotNull);
    });

    group('generateVideo', () {
      test('throws exception if multipartRequest not set up', () {
        final repository = ConvertRepository(url: 'url');
        expect(repository.generateVideo(frames), throwsException);
      });

      test('throws ConvertException on empty frames', () async {
        await expectLater(
          () async => convertRepository.generateVideo([]),
          throwsA(isA<GenerateVideoException>()),
        );
      });

      test('throws ConvertException if toByteData fails', () async {
        when(() => image.toByteData(format: ui.ImageByteFormat.png))
            .thenThrow(Exception());
        await expectLater(
          () async => convertRepository.generateVideo([]),
          throwsA(isA<GenerateVideoException>()),
        );
      });

      test('return ConvertResponse with video, gif and first frame', () async {
        when(() => streamedResponse.statusCode).thenReturn(200);
        when(() => streamedResponse.stream).thenAnswer(
          (_) => ByteStream.fromBytes(
            '{"video_url": "video", "gif_url": "gif"}'.codeUnits,
          ),
        );

        final response = await convertRepository.generateVideo(frames);

        expect(response.videoUrl, equals('video'));
        expect(response.gifUrl, equals('gif'));
        expect(response.firstFrame, Uint8List(1));
      });

      test('throws ConvertException on status code different than 200',
          () async {
        when(() => streamedResponse.statusCode).thenReturn(1);

        await expectLater(
          () async => convertRepository.generateVideo(frames),
          throwsA(isA<GenerateVideoException>()),
        );
      });
    });
  });
}
