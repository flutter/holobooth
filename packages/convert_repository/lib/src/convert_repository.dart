import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';

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
  });

  /// {@macro convert_response}
  factory ConvertResponse.fromJson(Map<String, dynamic> json) {
    return ConvertResponse(
      videoUrl: json['video_url'] as String,
      gifUrl: json['gif_url'] as String,
    );
  }

  /// Url to download the video.
  final String videoUrl;

  /// Url to download the gif.
  final String gifUrl;
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

  /// Converts a list of images to video using firebase functions.
  /// On success, returns the video path from the cloud storage.
  /// On error it throws a [ConvertException].
  Future<ConvertResponse> convertFrames(List<Uint8List> frames) async {
    if (frames.isEmpty) {
      throw const ConvertException('No frames to convert');
    }
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
        return ConvertResponse.fromJson(json);
      } else {
        throw const ConvertException('Failed to convert frames');
      }
    } catch (error) {
      throw ConvertException(error.toString());
    }
  }
}
