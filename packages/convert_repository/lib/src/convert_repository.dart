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

/// {@template convert_repository}
/// Repository for converting frames in video.
/// {@endtemplate}
class ConvertRepository {
  /// {@macro convert_repository}
  ConvertRepository({
    required String url,
    MultipartRequest? multipartRequest,
  }) : _multipartRequest =
            multipartRequest ?? MultipartRequest('POST', Uri.parse(url));

  final MultipartRequest _multipartRequest;

  /// Converts a list of images to video using firebase functions.
  /// On success, returns the video path from the cloud storage.
  /// On error it throws a [ConvertException].
  Future<String> convertFrames(List<Uint8List> frames) async {
    if (frames.isEmpty) {
      throw const ConvertException('No frames to convert');
    }
    try {
      for (var index = 0; index < frames.length; index++) {
        _multipartRequest.files.add(
          MultipartFile.fromBytes(
            'frames',
            frames[index],
            filename: 'frame_$index.png',
          ),
        );
      }

      final response = await _multipartRequest.send();
      if (response.statusCode == 200) {
        return response.stream.bytesToString();
      } else {
        throw const ConvertException('Failed to convert frames');
      }
    } catch (error) {
      throw ConvertException(error.toString());
    }
  }
}
