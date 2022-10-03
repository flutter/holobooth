/// Collection of equivalent Dart types matching TensorFlow's TypeScript
/// implementation.
///
/// See also:
/// * TypeScript types at: https://github.com/tensorflow/tfjs-models/blob/master/face-landmarks-detection/src/types.ts
import 'dart:collection';

typedef Faces = List<Face>;

abstract class FaceLandmarksDetector {
  Future<Faces> estimateFaces(
    dynamic object, {
    EstimationConfig estimationConfig = const EstimationConfig(),
  });

  void dispose();
}

/// {@template types.face_landmar_types.Face}
/// A face detected by [FaceLandmarksDetector].
///
/// The face is represented by [keypoints].
/// {@endtemplate}
class Face {
  const Face._(this.keypoints, this.boundingBox);

  factory Face.fromJson(Map<String, dynamic> json) {
    final keypointsJson = json['keypoints'] as List<dynamic>;
    final bondingBoxJson = json['box'] as Map<String, dynamic>;
    return Face._(
      UnmodifiableListView(
        keypointsJson.map(
          (keypoint) => Keypoint.fromJson(keypoint as Map<String, dynamic>),
        ),
      ),
      BoundingBox.fromJson(bondingBoxJson),
    );
  }

  /// Points representing the face landmarks.
  ///
  /// The order of the [keypoints] is significant, the mappings of these indexes
  /// to face locations can be found at:
  /// * https://github.com/tensorflow/tfjs-models/blob/master/face-landmarks-detection/mesh_map.jpg
  final UnmodifiableListView<Keypoint> keypoints;

  final BoundingBox boundingBox;

  Face copyWith({
    UnmodifiableListView<Keypoint>? keypoints,
    BoundingBox? boundingBox,
  }) =>
      Face._(
        keypoints ?? this.keypoints,
        boundingBox ?? this.boundingBox,
      );
}

/// {@template types.face_landmar_types.Keypoint}
/// Representation of a [Face] landmark point.
///
/// {@endtemplate}
class Keypoint {
  Keypoint._(this.x, this.y, this.z, this.score, this.name);

  factory Keypoint.fromJson(Map<String, dynamic> json) {
    return Keypoint._(
      json['x'] as num,
      json['y'] as num,
      json['z'] as num?,
      json['score'] as num?,
      json['name'] as String?,
    );
  }

  final num x;
  final num y;
  final num? z;
  final num? score;
  final String? name;

  Keypoint copyWith({
    num? x,
    num? y,
    num? z,
    num? score,
    String? name,
  }) {
    return Keypoint._(
      x ?? this.x,
      y ?? this.y,
      z ?? this.z,
      score ?? this.score,
      name ?? this.name,
    );
  }
}

/// {@template types.face_landmar_types.BoundingBox}
/// The box represents the bounding box of the face in the image pixel space,
/// with xMin, xMax denoting the x-bounds, yMin, yMax denoting the y-bounds,
/// and width, height are the dimensions of the bounding box.
///
/// {@endtemplate}
class BoundingBox {
  BoundingBox._(
    this.xMin,
    this.yMin,
    this.xMax,
    this.yMax,
    this.width,
    this.height,
  );

  BoundingBox.fromJson(Map<String, dynamic> map)
      : this._(
          map['xMin'] as num,
          map['yMin'] as num,
          map['xMax'] as num,
          map['yMax'] as num,
          map['width'] as num,
          map['height'] as num,
        );
  // TODO(oscar): check if worth to use double instead
  final num xMin;
  final num yMin;
  final num xMax;
  final num yMax;
  final num width;
  final num height;
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
