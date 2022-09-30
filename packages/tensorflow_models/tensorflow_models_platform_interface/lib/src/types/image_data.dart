import 'dart:typed_data';

/// {@template tensorflow_models.types.ImageData}
/// Representation of an image.
/// {@endtemplate}
class ImageData {
  const ImageData({
    required this.data,
    required this.width,
    required this.height,
  });

  /// Bytes of the image.
  final Uint8List data;

  /// Width of the image.
  final int width;

  /// Height of the image.
  final int height;
}
