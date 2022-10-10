import 'dart:convert' show jsonEncode;
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:gif_compositor_platform_interface/gif_compositor_platform_interface.dart';
import 'package:isolated_worker/js_isolated_worker.dart' as isolate;

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
    assert(fileName.endsWith('.gif'), 'fileName must end with ".gif"');

    await isolate.JsIsolatedWorker().importScripts(['encoder_worker.js']);

    // TODO(alestiago): Consider better approach to serialize/deserialize
    // arguements.
    // This will be passed into our javascript worker.
    final json = <String, dynamic>{};

    // TODO(alestiago): Investiagate if we can avoid doing these copies
    // to improve performance.
    final intList = <List<int>>[];
    for (final bytes in images) {
      intList.add(bytes.toList());
    }
    json.putIfAbsent('images', () => intList);

    final jsonString = jsonEncode(json);
    // TODO(alestiago): Investigate why we are not using a single
    // `isolate.JsIsolatedWorker()` object.
    final gif = await isolate.JsIsolatedWorker().run(
      functionName: 'encoder',
      arguments: jsonString,
    ) as List<int>;

    return XFile.fromData(
      Uint8List.fromList(gif),
      mimeType: 'image/gif',
      name: fileName,
    );
  }
}
