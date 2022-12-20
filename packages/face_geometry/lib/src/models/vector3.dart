import 'dart:math' as math;

import 'package:equatable/equatable.dart';

/// {@template vector3}
/// A 3D vector.
/// {@endtemplate}
class Vector3 extends Equatable {
  /// {@macro vector3}
  const Vector3(this.x, this.y, this.z);

  /// A vector with all components set to zero.
  static const zero = Vector3(0, 0, 0);

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

  /// Add this vector to another.
  Vector3 operator +(Vector3 other) =>
      Vector3(x + other.x, y + other.y, z + other.z);

  /// Subtract another vector from this vector.
  Vector3 operator -(Vector3 other) =>
      Vector3(x - other.x, y - other.y, z - other.z);

  /// The euclidean distance between this vector and another.
  double distance(Vector3 other) {
    final dx = x - other.x;
    final dy = y - other.y;
    final dz = z - other.z;
    return math.sqrt((dx * dx) + (dy * dy) + (dz * dz));
  }

  @override
  String toString() => 'Vector3($x, $y, $z)';

  @override
  List<Object?> get props => [x, y, z];
}
