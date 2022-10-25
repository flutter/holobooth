import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:tensorflow_models_web/src/face_landmarks_detection/interop/interop.dart';

class FaceLandmarksDetectorJs {
  @visibleForTesting
  html.Window? window;

  html.Window get _window => this.window ?? html.window;

  Future<FaceLandmarksDetector> createDetector(
    dynamic model, [
    ModelConfig? config,
  ]) {
    _window.
  }
}
