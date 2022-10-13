import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as tf;

/// {@template FaceDirection}
/// Calculation to detect the direction of the face.
/// {@endtemplate}
extension FaceDirection on tf.Face {
  /// {@macro FaceDirection}
  Vector3 direction() {
    final leftCheeck = keypoints[127];
    final rightCheeck = keypoints[356];
    final nose = keypoints[6];
    final leftCheeckVector = Vector3(
      leftCheeck.x.toDouble(),
      leftCheeck.y.toDouble(),
      leftCheeck.z?.toDouble() ?? 0,
    );
    final rightCheeckVector = Vector3(
      rightCheeck.x.toDouble(),
      rightCheeck.y.toDouble(),
      rightCheeck.z?.toDouble() ?? 0,
    );
    final noseVector = Vector3(
      nose.x.toDouble(),
      nose.y.toDouble(),
      nose.z?.toDouble() ?? 0,
    );
    return _equationOfAPlane(leftCheeckVector, rightCheeckVector, noseVector);
  }
}

/// {@template vector3}
/// A 3D vector.
/// {@endtemplate}
class Vector3 {
  /// {@macro vector3}
  Vector3(this.x, this.y, this.z);

  /// The x coordinate.
  final double x;

  /// The y coordinate.
  final double y;

  /// The z coordinate.
  final double z;
}

Vector3 _equationOfAPlane(Vector3 x, Vector3 y, Vector3 z) {
  final x1 = x.x;
  final y1 = x.y;
  final z1 = x.z;
  final x2 = y.x;
  final y2 = y.y;
  final z2 = y.z;
  final x3 = z.x;
  final y3 = z.y;
  final z3 = z.z;
  final a1 = x2 - x1;
  final b1 = y2 - y1;
  final c1 = z2 - z1;
  final a2 = x3 - x1;
  final b2 = y3 - y1;
  final c2 = z3 - z1;
  final a = b1 * c2 - b2 * c1;
  final b = a2 * c1 - a1 * c2;
  final c = a1 * b2 - b1 * a2;
  return Vector3(a, b, c);
}
