import 'dart:math' as math;

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

  /// The unit vector of this vector.
  Vector3 unit() {
    final length = math.sqrt(x * x + y * y + z * z);
    return Vector3(x / length, y / length, z / length);
  }

  /// Multiply this vector by a scalar.
  Vector3 operator *(double value) => Vector3(x * value, y * value, z * value);

  @override
  String toString() => 'Vector3($x, $y, $z)';
}
