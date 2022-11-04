/// Collection of equivalent Dart types matching TensorFlow's TypeScript
/// implementation.
///
/// See also:
///
/// * [TypeScript types implementation](https://github.com/tensorflow/tfjs-models/blob/master/face-landmarks-detection/src/types.ts)

import 'package:json_annotation/json_annotation.dart';
part 'types.g.dart';

import 'package:meta/meta.dart';

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
@JsonSerializable()
class Face {
  const Face(this.keypoints, this.boundingBox);

  factory Face.fromJson(Map<String, dynamic> json) {
    return _$FaceFromJson(json);

  }

  /// Points representing the face landmarks.
  ///
  /// The order of the [keypoints] is significant, the mappings of these indexes
  /// to face locations can be found [here](https://github.com/tensorflow/tfjs-models/blob/master/face-landmarks-detection/mesh_map.jpg).
  ///
  /// MediaPipeFaceMesh has 468 keypoints.
  final List<Keypoint> keypoints;

  // A bounding box around the detected face.
  @JsonKey(name: 'box')
  final BoundingBox boundingBox;

  Face copyWith({
    List<Keypoint>? keypoints,
    BoundingBox? boundingBox,
  }) =>
      Face(
        keypoints ?? this.keypoints,
        boundingBox ?? this.boundingBox,
      );
}

/// Representation of a [Face] landmark point.
///
/// See also:
///
/// * [TypeScript interface implementation](https://github.com/tensorflow/tfjs-models/blob/master/shared/calculators/interfaces/common_interfaces.ts)
@JsonSerializable()
class Keypoint {
  Keypoint(this.x, this.y, this.z, this.score, this.name);


  factory Keypoint.fromJson(Map<String, dynamic> json) {
    return _$KeypointFromJson(json);
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
    return Keypoint(
      x ?? this.x,
      y ?? this.y,
      z ?? this.z,
      score ?? this.score,
      name ?? this.name,
    );
  }
}

/// Represents the bounding box of the face in the image pixel space.
///
/// See also:
///
/// * [TypeScript interface implementation](https://github.com/tensorflow/tfjs-models/blob/master/shared/calculators/interfaces/shape_interfaces.ts/)
@JsonSerializable(fieldRename: FieldRename.none)
class BoundingBox {
  BoundingBox(
    this.xMin,
    this.yMin,
    this.xMax,
    this.yMax,
    this.width,
    this.height,
  );

  factory BoundingBox.fromJson(Map<String, dynamic> json) {
    return _$BoundingBoxFromJson(json);
  }
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

  BoundingBox copyWith({
    num? xMin,
    num? yMin,
    num? xMax,
    num? yMax,
    num? width,
    num? height,
  }) {
    return BoundingBox(
      xMin ?? this.xMin,
      yMin ?? this.yMin,
      xMax ?? this.xMax,
      yMax ?? this.yMax,
      width ?? this.width,
      height ?? this.height,
    );
  }
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
