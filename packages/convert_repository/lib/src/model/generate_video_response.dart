import 'dart:typed_data';

/// {@template generate_video_response}
/// Response data for the convert operation.
/// {@endtemplate}
class GenerateVideoResponse {
  /// {@macro generate_video_response}
  const GenerateVideoResponse({
    required this.videoUrl,
    required this.gifUrl,
    required this.firstFrame,
    this.twitterUrl = '',
    this.facebookShareUrl = '',
  });

  /// {@macro generate_video_response}
  factory GenerateVideoResponse.fromJson(
    Map<String, dynamic> json,
    Uint8List firstFrame,
  ) {
    return GenerateVideoResponse(
      videoUrl: json['video_url'] as String,
      gifUrl: json['gif_url'] as String,
      firstFrame: firstFrame,
    );
  }

  /// Url to download the video.
  final String videoUrl;

  /// Url to download the gif.
  final String gifUrl;

  /// First frame of the video generated.
  final Uint8List firstFrame;

  /// Twitter share url.
  final String twitterUrl;

  /// Facebook share url.
  final String facebookShareUrl;

  /// CopyWith
  GenerateVideoResponse copyWith({
    String? videoUrl,
    String? gifUrl,
    Uint8List? firstFrame,
    String? twitterUrl,
    String? facebookShareUrl,
  }) {
    return GenerateVideoResponse(
      videoUrl: videoUrl ?? this.videoUrl,
      gifUrl: gifUrl ?? this.gifUrl,
      firstFrame: firstFrame ?? this.firstFrame,
      twitterUrl: twitterUrl ?? this.twitterUrl,
      facebookShareUrl: facebookShareUrl ?? this.facebookShareUrl,
    );
  }
}
