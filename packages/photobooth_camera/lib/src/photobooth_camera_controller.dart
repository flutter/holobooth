import 'dart:html' as html;

import 'package:camera/camera.dart';

/// A constant that is true if the application was compiled to run on the web.
///
/// This implementation takes advantage of the fact that JavaScript does not
/// support integers. In this environment, Dart's doubles and ints are
/// backed by the same kind of object. Thus a double `0.0` is identical
/// to an integer `0`. This is not true for Dart code running in AOT or on the
/// VM.
const _kIsWeb = identical(0, 0.0);

/// A [CameraController] extension with utilities to be used in the Photbooth
/// application.
extension PhotboothCameraController on CameraController {
  /// Retrieves the [html.VideoElement] from the camera preview.
  ///
  /// **NOTE**: This method assumes it is being used in an enviroment
  /// where there is only a single [html.VideoElement] in the DOM.
  dynamic get videoElement {
    assert(_kIsWeb, 'videoElement is only available on the web');
    final videoElement = html.querySelector('video')! as html.VideoElement;
    return videoElement;
  }
}
