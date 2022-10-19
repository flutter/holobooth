import 'dart:typed_data';

/// {@template tensorflow_models_platform_interface.types.ImageData}
/// Stores the data about an image.
/// {@endtemplate}
class ImageData {
  /// {@macro tensorflow_models_platform_interface.types.ImageData}
  const ImageData({
    required this.bytes,
    required this.size,
  });

  /// Bytes of the image.
  final Uint8List bytes;

  /// Size of the image.
  final Size size;
}

/// {@template size}
/// Holds a 2D point size.
/// {@endtemplate}
class Size {
  /// {@macro size}
  Size(this.width, this.height);

  /// The horizontal extent of this size.
  final int width;

  /// The vertical extent of this size.
  final int height;
}
