import 'dart:convert';
import 'dart:ui';

import 'package:convert_repository/convert_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

/// {@template convert_repository}
/// Repository for converting frames in video.
/// {@endtemplate}
class ConvertRepository {
  /// {@macro convert_repository}
  ConvertRepository({
    required String url,
    required String shareUrl,
    required String assetBucketUrl,
    MultipartRequest Function()? multipartRequestBuilder,
    List<Uint8List>? processedFrames,
  })  : _shareUrl = shareUrl,
        _assetBucketUrl = assetBucketUrl,
        _processedFrames = processedFrames ?? [] {
    _multipartRequestBuilder = multipartRequestBuilder ??
        () => MultipartRequest('POST', Uri.parse(url));
  }

  late final MultipartRequest Function() _multipartRequestBuilder;
  final List<Uint8List> _processedFrames;
  final String _shareUrl;
  final String _assetBucketUrl;

  /// 16 is the minimum amount of time that you can delay
  /// an operation on a web browser.
  // https://developer.mozilla.org/en-US/docs/Web/Performance/Animation_performance_and_frame_rate#:~:text=However%2C%20the%20performance,smooth%20frame%20rate.
  @visibleForTesting
  static const webMinimumFrameDuration = Duration(milliseconds: 16);

  Future<Uint8List?> _getBytesFromImage(Image image) async {
    final bytesImage = await image.toByteData(format: ImageByteFormat.png);
    return bytesImage?.buffer.asUint8List();
  }

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

  /// Process a list of [Image] and convert them to a list of [Uint8List].
  Future<List<Uint8List>> processFrames(List<Image> preProcessedFrames) async {
    _processedFrames.clear();

    final frames = await _processFrames(preProcessedFrames);
    return frames;
  }

  /// Converts a list of images to video using firebase functions.
  ///
  /// On success, returns the video path from the cloud storage.
  ///
  /// On error it throws a [GenerateVideoException].
  Future<GenerateVideoResponse> generateVideo() async {
    if (_processedFrames.isEmpty) {
      throw const GenerateVideoException('No frames to convert');
    }

    try {
      final multipartRequest = _multipartRequestBuilder();
      for (var index = 0; index < _processedFrames.length; index++) {
        multipartRequest.files.add(
          MultipartFile.fromBytes(
            'frames',
            _processedFrames[index],
            filename: 'frame_$index.png',
          ),
        );
      }

      final response = await multipartRequest.send();
      if (response.statusCode == 200) {
        final rawData = await response.stream.bytesToString();
        final json = jsonDecode(rawData) as Map<String, dynamic>;
        final videoResponse = GenerateVideoResponse.fromJson(
          json,
          _processedFrames.first,
        );
        final shareUrl = _getShareUrl(videoResponse.videoUrl);
        final shareText = Uri.encodeComponent(
          'A new reality awaits in the #FlutterHolobooth. '
          'See you at #FlutterForward!',
        );
        return videoResponse.copyWith(
          twitterShareUrl: _getTwitterShareUrl(shareUrl, shareText),
          facebookShareUrl: _getFacebookShareUrl(shareUrl, shareText),
        );
      } else {
        throw const GenerateVideoException('Failed to convert frames');
      }
    } catch (error) {
      throw GenerateVideoException(error.toString());
    }
  }

  String _getShareUrl(String fullPath) {
    // TODO(OSCAR): We could do the parsing on the cloud function
    final assetName = fullPath.replaceAll(_assetBucketUrl, '');
    return _shareUrl + assetName;
  }

  String _getTwitterShareUrl(String shareUrl, String shareText) {
    return 'https://twitter.com/intent/tweet?url=$shareUrl&text=$shareText';
  }

  String _getFacebookShareUrl(String shareUrl, String shareText) {
    return 'https://www.facebook.com/sharer.php?u=$shareUrl&quote=$shareText';
  }
}
