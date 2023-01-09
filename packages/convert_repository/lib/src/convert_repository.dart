import 'dart:convert';
import 'dart:ui';

import 'package:convert_repository/convert_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:screen_recorder/screen_recorder.dart';

/// {@template convert_repository}
/// Repository for converting frames in video.
/// {@endtemplate}
class ConvertRepository {
  /// {@macro convert_repository}
  ConvertRepository({
    required String url,
    MultipartRequest Function()? multipartRequestBuilder,
  }) {
    _multipartRequestBuilder = multipartRequestBuilder ??
        () => MultipartRequest('POST', Uri.parse(url));
  }

  late final MultipartRequest Function() _multipartRequestBuilder;

  final _processedFrames = <Uint8List>[];

  /// 16 is the minimum amount of time that you can delay
  /// an operation on a web browser.
  // https://developer.mozilla.org/en-US/docs/Web/Performance/Animation_performance_and_frame_rate#:~:text=However%2C%20the%20performance,smooth%20frame%20rate.
  @visibleForTesting
  static const webMinimumFrameDuration = Duration(milliseconds: 16);

  Future<Uint8List?> _getBytesFromImage(Image image) async {
    final bytesImage = await image.toByteData(format: ImageByteFormat.png);
    return bytesImage?.buffer.asUint8List();
  }

  /// Process a list of [Frame] and convert them to a list of [Uint8List].
  Future<List<Uint8List>> _processFrames(List<Image> preProcessedFrames) async {
    final bytes = await _getBytesFromImage(
      preProcessedFrames[_processedFrames.length],
    );
    if (bytes != null) {
      _processedFrames.add(bytes);
    }
    if (_processedFrames.length < preProcessedFrames.length) {
      await Future<void>.delayed(
        webMinimumFrameDuration,
        () => _processFrames(preProcessedFrames),
      );
    }
    return _processedFrames;
  }

  /// Converts a list of images to video using firebase functions.
  ///
  /// On success, returns the video path from the cloud storage.
  ///
  /// On error it throws a [GenerateVideoException].
  Future<GenerateVideoResponse> generateVideo(
    List<Image> preProcessedFrames,
  ) async {
    if (preProcessedFrames.isEmpty) {
      throw const GenerateVideoException('No frames to convert');
    }

    try {
      _processedFrames.clear();
      final frames = await _processFrames(preProcessedFrames);
      final multipartRequest = _multipartRequestBuilder();
      for (var index = 0; index < frames.length; index++) {
        multipartRequest.files.add(
          MultipartFile.fromBytes(
            'frames',
            frames[index],
            filename: 'frame_$index.png',
          ),
        );
      }

      final response = await multipartRequest.send();
      if (response.statusCode == 200) {
        final rawData = await response.stream.bytesToString();
        final json = jsonDecode(rawData) as Map<String, dynamic>;
        return GenerateVideoResponse.fromJson(
          json,
          frames.first,
        );
      } else {
        throw const GenerateVideoException('Failed to convert frames');
      }
    } catch (error) {
      throw GenerateVideoException(error.toString());
    }
  }
}
