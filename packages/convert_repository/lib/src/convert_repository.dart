import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:http/http.dart';
import 'package:screen_recorder/screen_recorder.dart';

/// {@template convert_exception}
/// Exception thrown when convert frames fails.
/// {@endtemplate}
class ConvertException implements Exception {
  /// {@macro convert_exception}
  const ConvertException(this.message);

  /// Description of the failure
  final String message;

  @override
  String toString() => message;
}

/// {@template convert_response}
/// Response data for the convert operation.
/// {@endtemplate}
class ConvertResponse {
  /// {@macro convert_response}
  const ConvertResponse({
    required this.videoUrl,
    required this.gifUrl,
    required this.firstFrame,
  });

  /// {@macro convert_response}
  factory ConvertResponse.fromJson(
      Map<String, dynamic> json, Uint8List firstFrame) {
    return ConvertResponse(
      videoUrl: json['video_url'] as String,
      gifUrl: json['gif_url'] as String,
      firstFrame: firstFrame,
    );
  }

  /// Url to download the video.
  final String videoUrl;

  /// Url to download the gif.
  final String gifUrl;

  final Uint8List firstFrame;
}

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

  Future<Uint8List?> _getFrameData(Image image) async {
    final bytesImage = await image.toByteData(format: ImageByteFormat.png);
    return bytesImage?.buffer.asUint8List();
  }

  Future<List<Uint8List>> _processFrames(List<Frame> preProcessedFrames) async {
    final bytes = await _getFrameData(
      preProcessedFrames[_processedFrames.length].image,
    );

    if (bytes != null) {
      _processedFrames.add(bytes);
    }
    if (_processedFrames.length < preProcessedFrames.length) {
      await Future<void>.delayed(
        const Duration(
          milliseconds: 10,
        ), // Cualquier cosa < de 16 en el browser va a ser ~16
        () => _processFrames(preProcessedFrames),
      );
    } // else we're done, nothing to return.
    return _processedFrames;
  }

  /// Converts a list of images to video using firebase functions.
  /// On success, returns the video path from the cloud storage.
  /// On error it throws a [ConvertException].
  Future<ConvertResponse> generateVideo(List<Frame> preProcessedFrames) async {
    if (preProcessedFrames.isEmpty) {
      throw const ConvertException('No frames to convert');
    }
    final frames = await _processFrames(preProcessedFrames);
    try {
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
        return ConvertResponse.fromJson(
          json,
          frames.first,
        );
      } else {
        throw const ConvertException('Failed to convert frames');
      }
    } catch (error) {
      throw ConvertException(error.toString());
    }
  }
}
