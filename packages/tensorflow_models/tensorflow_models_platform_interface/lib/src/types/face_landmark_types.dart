typedef Faces = List<Face>;

class Keypoint {
  Keypoint(this.x, this.y, this.z, this.score, this.name);

  final num x;
  final num y;
  final num? z;
  final num? score;
  final String? name;
}

class Face {
  const Face(this.keypoints);

  factory Face.fromJs(List<dynamic> keyPointsJs) {
    return Face(
      keyPointsJs.map(
        (e) {
          final map = e as Map<String, dynamic>;
          return Keypoint(
            map['x'] as num,
            map['y'] as num,
            map['z'] as num?,
            map['score'] as num?,
            map['name'] as String?,
          );
        },
      ).toList(),
    );
  }

  final List<Keypoint> keypoints;
}

/// {@template types.face_landmark_types.EstimationConfig}
/// Configuration for the estimation of the face landmarks.
/// {@endtemplate}
class EstimationConfig {
  /// {@macro types.face_landmark_types.EstimationConfig}
  const EstimationConfig({
    this.flipHorizontal = false,
    this.staticImageMode = true,
  });

  /// Whether to flip the image horizontally.
  final bool flipHorizontal;

  /// Whether the image should be treated as a video stream or a single image.
  ///
  /// If set to true, face detection runs on every input image, ideal for
  /// processing a batch of static, possibly unrelated, images.
  ///
  /// If set to false, face detection runs on the first images, and then tracks
  /// the face landmarks. This reduces latency and is ideal for processing video
  /// frames.
  ///
  /// See also:
  ///
  /// * https://google.github.io/mediapipe/solutions/face_mesh.html#static_image_mode
  final bool staticImageMode;
}

abstract class FaceLandmarksDetector {
  Future<Faces> estimateFaces(
    dynamic object, {
    EstimationConfig estimationConfig = const EstimationConfig(),
  });

  void dispose();
}
