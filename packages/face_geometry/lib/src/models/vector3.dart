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

  @override
  String toString() => 'Vector3($x, $y, $z)';

  @override
  List<Object?> get props => [x, y, z];
}
