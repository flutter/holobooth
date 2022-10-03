/// Collection of equivalent Dart types matching TensorFlow's TypeScript
/// implementation.
///
/// See also:
///
/// * [TypeScript types implementation](https://github.com/tensorflow/tfjs-models/blob/master/face-landmarks-detection/src/types.ts)
import 'dart:collection';

typedef Faces = List<Face>;

abstract class FaceLandmarksDetector {
  Future<Faces> estimateFaces(
    dynamic object, {
    EstimationConfig estimationConfig = const EstimationConfig(),
  });

  void dispose();
}

/// A face detected by [FaceLandmarksDetector].
///
/// The face is represented by [keypoints].
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
  /// to face locations can be found [here](https://github.com/tensorflow/tfjs-models/blob/master/face-landmarks-detection/mesh_map.jpg).
  ///
  /// MediaPipeFaceMesh has 468 keypoints.
  final UnmodifiableListView<Keypoint> keypoints;

  // A bounding box around the detected face.
  final BoundingBox boundingBox;
}

/// Representation of a [Face] landmark point.
///
/// See also:
///
/// * [TypeScript interface implementation](https://github.com/tensorflow/tfjs-models/blob/master/shared/calculators/interfaces/common_interfaces.ts)
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
}

/// Represents the bounding box of the face in the image pixel space.
///
/// See also:
///
/// * [TypeScript interface implementation](https://github.com/tensorflow/tfjs-models/blob/master/shared/calculators/interfaces/shape_interfaces.ts/)
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
  // TODO(oscar): check if worth to use double instead.

  /// The x-coordinate of the top-left corner of the bounding box.
  final num xMin;

  /// The y-coordinate of the top-left corner of the bounding box.
  final num yMin;

  /// The x-coordinate of the bottom-right corner of the bounding box.
  final num xMax;

  /// The y-coordinate of the bottom-right corner of the bounding box.
  final num yMax;

  /// The width of the bounding box.
  final num width;

  /// The height of the bounding box.
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
