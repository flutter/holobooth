// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:tensorflow_models/tensorflow_models.dart';

/// {@template avatar_detector_repository}
/// Repository, based on TensorFlow, that retrieves avatar
/// representation information from a given source.
/// {@endtemplate}
class AvatarDetectorRepository {
  /// {@macro avatar_detector_repository}
  AvatarDetectorRepository({FaceLandmarksDetector? faceLandmarksDetector})
      : _faceLandmarksDetector = faceLandmarksDetector;

  FaceLandmarksDetector? _faceLandmarksDetector;

  /// Preload an instance of [FaceLandmarksDetector].
  ///
  /// Throws [PreloadLandmarksModelException] if amy exception occurs.
  ///
  /// Note: Highly recommended to call this method before any other
  /// like [detectFace] to speed up the whole process.
  Future<void> preloadLandmarksModel() async {
    try {
      _faceLandmarksDetector = await TensorFlowFaceLandmarks.load();
    } catch (e) {
      throw PreloadLandmarksModelException(e.toString());
    }
  }

  /// Return [Face] if there is any on the [input].
  ///
  /// Throws [DetectFaceException] if amy exception occurs.
  Future<Face?> detectFace(dynamic input) async {
    if (_faceLandmarksDetector == null) {
      await preloadLandmarksModel();
    }
    Faces faces;
    try {
      faces = await _faceLandmarksDetector!.estimateFaces(input);
    } catch (e) {
      throw DetectFaceException(e.toString());
    }
    if (faces.isEmpty) return null;

    return faces.first;
  }
}
