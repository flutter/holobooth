import 'dart:convert' show jsonEncode;
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:gif_compositor_platform_interface/gif_compositor_platform_interface.dart';
import 'package:isolated_worker/js_isolated_worker.dart' as isolate;

const _gifCompositorWorkerFileName = 'gif_compositor_worker.js';

/// The Web implementation of [GifCompositorPlatform].
class GifCompositorWeb extends GifCompositorPlatform {
  /// Registers this class as the default instance of [GifCompositorPlatform]
  static void registerWith([Object? registrar]) {
    GifCompositorPlatform.instance = GifCompositorWeb();
  }

  @override
  Future<XFile> composite({
    required List<Uint8List> images,
    required String fileName,
  }) async {
    assert(
      fileName.endsWith(_Gif.fileExtension),
      'fileName must end with ".gif"',
    );

    final worker = isolate.JsIsolatedWorker();
    await worker.importScripts([_gifCompositorWorkerFileName]);

    final jsonString = jsonEncode(
      <String, dynamic>{
        'images': images,
      },
    );
    try {
      // FIXME(alestiago): Returns an error.
      final gif = await worker.run(
        functionName: 'encoder',
        arguments: jsonString,
      );

      return XFile.fromData(
        // TODO(alestiago): Investigate if we can avoid doing this copy.
        Uint8List.fromList(gif as List<int>),
        mimeType: _Gif.mimeType,
        name: fileName,
      );
    } catch (error) {
      throw GifCompositorException(error.toString());
    }
  }
}

abstract class _Gif {
  /// The file extension for a GIF file.
  static const fileExtension = '.gif';

  /// Inidicates the media type of a GIF file.
  ///
  /// See also:
  ///
  /// * [Wikipedia's MIME page](https://en.wikipedia.org/wiki/Media_type)
  static const mimeType = 'image/gif';
}
