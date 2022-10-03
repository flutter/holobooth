// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:tensorflow_models/tensorflow_models.dart';

/// {@template get_faces_exception}
/// Exception thrown when detectFace fails.
///
/// It contains a [message] field which describes the error.
/// {@endtemplate}
class DetectFaceException implements Exception {
  /// {@macro get_faces_exception}
  const DetectFaceException(this.message);

  /// Description of the failure
  final String message;

  @override
  String toString() => message;
}

/// {@template face_not_found_exception}
/// Exception thrown if detectFace return no face.
///
/// {@endtemplate}
class FaceNotFoundException extends DetectFaceException {
  /// {@macro face_not_found_exception}
  FaceNotFoundException(super.message);
}

/// {@template avatar_detector_repository}
/// Repository to give avatar information based on tensorflow implementation.
/// {@endtemplate}
class AvatarDetectorRepository {
  /// {@macro avatar_detector_repository}
  AvatarDetectorRepository({FaceLandmarksDetector? faceLandmarksDetector})
      : _faceLandmarksDetector = faceLandmarksDetector;

  FaceLandmarksDetector? _faceLandmarksDetector;

  /// Preload an instance of [FaceLandmarksDetector].
  ///
  /// Recommended to call this method before to speed up detection
  Future<void> preloadLandmarksModel() async {
    _faceLandmarksDetector = await TensorFlowFaceLandmarks.load();
  }

  Future<Face> detectFace(dynamic input) async {
    if (_faceLandmarksDetector == null) {
      await preloadLandmarksModel();
    }
    Faces faces;
    try {
      faces = await _faceLandmarksDetector!.estimateFaces(input);
    } catch (e) {
      throw DetectFaceException(e.toString());
    }
    if (faces.isEmpty) {
      throw FaceNotFoundException('detectFace does not return any face');
    }
    return faces.first;
  }
}
