import 'dart:typed_data';

/// {@template tensorflow_models_platform_interface.types.ImageData}
/// Stores the data about an image.
/// {@endtemplate}
class ImageData {
  /// {@macro tensorflow_models_platform_interface.types.ImageData}
  const ImageData({
    required this.bytes,
    required this.width,
    required this.height,
  });

  /// Bytes of the image.
  final Uint8List bytes;

  /// Width of the image.
  final int width;

  /// Height of the image.
  final int height;
}
