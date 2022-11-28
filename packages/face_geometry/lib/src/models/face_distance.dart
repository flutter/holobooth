import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

/// {@template face_distance}
/// Calculation to detect the distance of the face from the camera.
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
        boundingBox.width.toInt().clamp(0, imageSize.width),
        boundingBox.height.toInt().clamp(0, imageSize.height),
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
      boundingBoxSize.width <= imageSize.width,
      'The boundingBoxSize width must be less than the imageSize width.',
    );
    assert(
      boundingBoxSize.height <= imageSize.height,
      'The boundingBoxSize height must be less than the imageSize height.',
    );

    final imageArea = imageSize.width * imageSize.height;
    final boundingBoxArea = boundingBoxSize.width * boundingBoxSize.height;
    return boundingBoxArea / imageArea;
  }

  /// The value that correlates to the distance the face is from the camera.
  ///
  /// The greater the value, the closer the user is to the camera.
  ///
  /// The value is between 0 and 1.
  final double value;

  @override
  List<Object?> get props => [value];
}
