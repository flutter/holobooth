/// {@template tf_size}
/// Holds a 2D floating-point size.
/// {@endtemplate}
class TFSize {
  /// {@macro tf_size}
  TFSize(this.width, this.height);

  /// The horizontal extent of this size.
  final num width;

  /// The vertical extent of this size.
  final num height;
}
