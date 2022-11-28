// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:tensorflow_models/tensorflow_models.dart';

/// {@template avatar_detector_repository}
/// Repository, based on TensorFlow, that retrieves avatar
/// representation information from a given source.
/// {@endtemplate}
class AvatarDetectorRepository {
  /// {@macro avatar_detector_repository}
  AvatarDetectorRepository();

  FaceLandmarksDetector? _faceLandmarksDetector;

  FaceGeometry? _faceGeometry;

  /// Preload an instance of [FaceLandmarksDetector].
  ///
  /// Throws [PreloadLandmarksModelException] if any exception occurs.
  ///
  /// Note: Highly recommended to call this method before any other
  /// like [detectAvatar] to speed up the whole process.
  Future<void> preloadLandmarksModel() async {
    try {
      _faceLandmarksDetector = await TensorFlowFaceLandmarks.load();
    } catch (error) {
      throw PreloadLandmarksModelException(error.toString());
    }
  }

  /// Return [Avatar] if there is any on the [input].
  ///
  /// Throws [DetectAvatarException] if any exception occurs.
  Future<Avatar?> detectAvatar(ImageData input) async {
    if (_faceLandmarksDetector == null) {
      await preloadLandmarksModel();
    }
    Faces faces;
    try {
      faces = await _faceLandmarksDetector!.estimateFaces(input);
    } catch (error) {
      throw DetectAvatarException(error.toString());
    }
    if (faces.isEmpty) return null;

    final face = faces.first;
    _faceGeometry = _faceGeometry == null
        ? FaceGeometry.fromFace(face)
        : _faceGeometry!.update(face);

    return Avatar.fromFaceGeometry(_faceGeometry!);
  }

  /// Disposes the instance of [FaceLandmarksDetector]
  void dispose() {
    _faceLandmarksDetector?.dispose();
  }
}
