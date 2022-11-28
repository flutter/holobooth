import 'package:equatable/equatable.dart';
import 'package:face_geometry/face_geometry.dart';
import 'package:meta/meta.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

/// {@template face_distance}
/// Calculation to detect the direction of the face.
/// {@endtemplate}
@immutable
class FaceDistance extends Equatable {
  /// {@macro face_distance}
  factory FaceDistance({
    required tf.BoundingBox boundingBox,
    required tf.Size imageSize,
  }) {
    return FaceDistance._compute(
      boundingBoxSize: tf.Size(
        boundingBox.width.toInt(),
        boundingBox.height.toInt(),
      ),
      imageSize: imageSize,
    );
  }

  FaceDistance._compute({
    required tf.Size boundingBoxSize,
    required tf.Size imageSize,
  }) : value = _value(
          boundingBoxSize: boundingBoxSize,
          imageSize: imageSize,
        );

  /// An empty instance of [MouthGeometry].
  ///
  /// This is used when the keypoints are not available.
  const FaceDistance._empty() : value = 0.5;

  static double _value({
    required tf.Size boundingBoxSize,
    required tf.Size imageSize,
  }) {
    assert(
      imageSize.width > 0,
      'The imageSize width must be greater than 0.',
    );
    assert(
      imageSize.height > 0,
      'The imageSize height must be greater than 0.',
    );
    assert(
      boundingBoxSize.width < imageSize.width,
      'The boundingBoxSize width must be less than the imageSize width.',
    );
    assert(
      boundingBoxSize.height < imageSize.height,
      'The boundingBoxSize height must be less than the imageSize height.',
    );

    final imageArea = imageSize.width * imageSize.height;
    final boundingBoxArea = boundingBoxSize.width * boundingBoxSize.height;
    return boundingBoxArea / imageArea;
  }

  /// The value of the distance.
  final double value;

  @override
  List<Object?> get props => [value];
}
