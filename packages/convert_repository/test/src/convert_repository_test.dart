import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:convert_repository/convert_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class _MockImage extends Mock implements ui.Image {}

class _MockMultipartRequest extends Mock implements MultipartRequest {}

class _MockStreamedResponse extends Mock implements StreamedResponse {}

void main() {
  group('ConvertRepository', () {
    late MultipartRequest multipartRequest;
    late ConvertRepository convertRepository;
    late StreamedResponse streamedResponse;
    late ui.Image image;
    late List<ui.Image> frames;
    late List<Uint8List> bytes;

    setUp(() async {
      multipartRequest = _MockMultipartRequest();

      streamedResponse = _MockStreamedResponse();

      when(() => multipartRequest.files).thenReturn([]);
      when(multipartRequest.send).thenAnswer(
        (_) async => streamedResponse,
      );

      image = _MockImage();
      when(() => image.toByteData(format: ui.ImageByteFormat.png))
          .thenAnswer((_) async => ByteData(1));
      frames = [
        image,
        image,
      ];

      final bytesImage = await image.toByteData(format: ImageByteFormat.png);
      bytes = [bytesImage!.buffer.asUint8List()];

      convertRepository = ConvertRepository(
        multipartRequestBuilder: () => multipartRequest,
        url: '',
        assetBucketUrl: '',
        shareUrl: '',
        processedFrames: bytes,
      );
    });

    test('can be instantiated', () {
      expect(
        ConvertRepository(
          url: '',
          assetBucketUrl: '',
          shareUrl: '',
        ),
        isNotNull,
      );
    });

    group('processFrames', () {
      test('does not skip frames during processing', () async {
        final response = await convertRepository.processFrames(frames);
        expect(response.length, frames.length);
      });
    });

    group('generateVideo', () {
      test('throws ConvertException on empty frames', () async {
        final repository = ConvertRepository(
          url: 'url',
          assetBucketUrl: '',
          shareUrl: '',
        );
        await expectLater(
          () async => repository.generateVideo(),
          throwsA(isA<GenerateVideoException>()),
        );
      });

      test('throws exception if multipartRequest not set up', () {
        final repository = ConvertRepository(
          url: 'url',
          assetBucketUrl: '',
          shareUrl: '',
          processedFrames: bytes,
        );
        expect(repository.generateVideo(), throwsException);
      });

      test(
        'return ConvertResponse with video, gif and first frame, and share '
        'urls',
        () async {
          when(() => streamedResponse.statusCode).thenReturn(200);
          when(() => streamedResponse.stream).thenAnswer(
            (_) => ByteStream.fromBytes(
              '{"video_url": "video", "gif_url": "gif"}'.codeUnits,
            ),
          );
          final response = await convertRepository.generateVideo();

          expect(response.videoUrl, equals('video'));
          expect(response.gifUrl, equals('gif'));
          expect(response.firstFrame, Uint8List(1));
          expect(response.twitterShareUrl, contains(response.videoUrl));
          expect(response.facebookShareUrl, contains(response.videoUrl));
        },
      );

      test('throws ConvertException on status code different than 200',
          () async {
        when(() => streamedResponse.statusCode).thenReturn(1);

        await expectLater(
          () async => convertRepository.generateVideo(),
          throwsA(isA<GenerateVideoException>()),
        );
      });
    });
  });
}
