/// {@template eye_blink}
/// An object which holds data for eye blink.
/// {@endtemplate}
class EyeBlink {
  /// {@macro eye_blink}
  EyeBlink({
    this.maxRatio,
    this.minRatio,
    this.firstAction = false,
  });

  /// The maximum ratio of the eye blink.
  double? maxRatio;

  /// The minimum ratio of the eye blink.
  double? minRatio;

  /// Define whether the first action, e.g. close, was detected and we have the
  /// correct min and max values.
  bool firstAction = false;

  /// Creates copy of [EyeBlink] object.
  EyeBlink copyWith({
    double? maxRatio,
    double? minRatio,
    bool? firstAction,
  }) =>
      EyeBlink(
        maxRatio: maxRatio ?? this.maxRatio,
        minRatio: minRatio ?? this.minRatio,
        firstAction: firstAction ?? this.firstAction,
      );
}
