import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:gif_compositor_platform_interface/gif_compositor_platform_interface.dart';

GifCompositorPlatform get _platform => GifCompositorPlatform.instance;

/// {@template gif_compositor}
/// Composites a list of images into a GIF.
///
/// See also:
///
/// * [Wikipedia's Gif article](https://en.wikipedia.org/wiki/GIF)
/// {@endtemplate}
abstract class GifCompositor {
  /// {@macro gif_compositor}
  static Future<XFile> composite({
    required List<Uint8List> images,
    required String fileName,
  }) async {
    return _platform.composite(
      images: images,
      fileName: fileName,
    );
  }
}
