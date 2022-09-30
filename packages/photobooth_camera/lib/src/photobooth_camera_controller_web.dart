// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

/// {@template photobooth_camera.photobooth_camera_controller_web.DomException}
/// An exception thrown when a DOM error occurs.
/// {@endtemplate}
class DomException implements Exception {
  /// {@macro photobooth_camera.photobooth_camera_controller_web.DomException}
  DomException(this.message);

  /// The error message.
  final String message;
}

/// A [CameraController] extension with utilities to be used in the Photbooth
/// application.
extension PhotboothCameraController on CameraController {
  /// Retrieves the [html.VideoElement] from the camera preview.
  ///
  /// Throws a [DomException] if no [html.VideoElement] is found.
  ///
  /// **NOTE**: This method assumes it is being used in an enviroment
  /// where there is only a single [html.VideoElement] in the DOM.
  html.VideoElement get videoElement {
    assert(kIsWeb, 'videoElement is only available on the web.');
    final videoElement = html.querySelector('video');
    if (videoElement == null) {
      throw DomException('No video element found.');
    } else {
      return videoElement as html.VideoElement;
    }
  }
}
