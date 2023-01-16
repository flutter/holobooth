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
    if (faces.isEmpty) {
      return null;
    }

    final face = faces.first;
    final faceGeometry = _faceGeometry = _faceGeometry == null
        ? FaceGeometry(face: face, size: input.size)
        : _faceGeometry!.update(face: face, size: input.size);

    final hasAllFaceKeypoints = face.keypoints.length == 478;
    final hasFaceOvalWithinBounds = face.keypoints
        .where((keypoint) => keypoint.name == 'faceOval')
        .every((keypoint) => keypoint.withinBounds(input.size));
    final avatarRecognized = hasAllFaceKeypoints && hasFaceOvalWithinBounds;
    if (!avatarRecognized) {
      return null;
    }

    return Avatar(
      hasMouthOpen: faceGeometry.mouth.isOpen,
      mouthDistance: faceGeometry.mouth.distance,
      rotation: faceGeometry.rotation.value,
      distance: faceGeometry.distance.value,
      leftEyeGeometry: faceGeometry.leftEye,
      rightEyeGeometry: faceGeometry.rightEye,
    );
  }

  /// Disposes the instance of [FaceLandmarksDetector]
  void dispose() {
    _faceLandmarksDetector?.dispose();
  }
}

extension on Keypoint {
  /// Whether the [Keypoint] is within the bounds of the [Size].
  bool withinBounds(Size size) {
    return 0 <= x && x <= size.width && 0 <= y && y <= size.height;
  }
}
