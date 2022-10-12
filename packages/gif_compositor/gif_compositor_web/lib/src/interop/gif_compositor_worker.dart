import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:js/js.dart';

/// The code that runs on a worker thread to create a GIF animation.
///
/// If changes are made to this file, you'll need to generate new js files.
/// In the root project directory, run this command:
/// ```
///   dart compile js packages/gif_compositor/gif_compositor_web/lib/src/interop/gif_compositor_worker.dart -o packages/tensorflow_models/tensorflow_models/example/web/gif_compositor_worker.js
/// ```
@JS('encoder')
external set worker(dynamic obj);
void main() {
  // args is the data that is passed in from the calling dart code and must be
  // a primitive. Here, args is a JSON object represented by a String.
  worker = allowInterop((String args) {
    try {
      // TODO(alestiago): Consider better approach to serialize/deserialize
      // arguements.
      final map = jsonDecode(args) as Map<String, dynamic>;
      final images = map['images'] as List<dynamic>;

      final animation = img.Animation();
      for (final bytes in images) {
        animation.addFrame(img.decodePng(bytes as Uint8List)!);
      }

      return img.encodeGifAnimation(animation);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  });
}
