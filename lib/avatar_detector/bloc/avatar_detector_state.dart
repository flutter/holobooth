part of 'avatar_detector_bloc.dart';

enum AvatarDetectorStatus {
  /// The tensorflow model has not been loaded and is not ready to estimate.
  initial,

  /// The tensorflow model is being loaded.
  loading,

  /// The tensorflow model has loaded.
  loaded,

  /// An error occurred while loading the tensorflow model or estimating.
  error,

  /// The tensorflow model is estimating the [Avatar] from the [CameraImage].
  estimating,

  /// The tensorflow model is warming up.
  ///
  /// Before them model reports an [Avatar] as detected, it needs to warm up to
  /// calibrate the face geometric data.
  warming,

  /// The [Avatar] has been detected.
  detected,

  /// The [Avatar] has not been detected.
  ///
  /// This occurs only when [estimating] the [Avatar] has failed for a certain
  /// amount of time, given by [AvatarDetectorBloc.undetectedDelay].
  notDetected;

  bool get hasLoadedModel =>
      this == loaded ||
      this == estimating ||
      this == detected ||
      this == notDetected ||
      this == warming;
}

class AvatarDetectorState extends Equatable {
  const AvatarDetectorState({
    this.status = AvatarDetectorStatus.initial,
    this.avatar = Avatar.zero,
    this.lastAvatarDetection,
    this.detectedAvatarCount = 0,
  });

  final AvatarDetectorStatus status;
  final Avatar avatar;

  /// The last time the [Avatar] was detected.
  ///
  /// Initially set to [DateTime.now] after the model is initialized then
  /// set to [DateTime.now] after every [Avatar] detection.
  ///
  /// Used to determine if the [Avatar] has been detected for a certain amount
  /// of time, which is given by [AvatarDetectorBloc.undetectedDelay].
  final DateTime? lastAvatarDetection;

  /// The number of [CameraImage]s with an [Avatar].
  ///
  /// The count stops at [AvatarDetectorBloc.warmingUpImages].
  ///
  /// Used to determine if the face geometric data of a person has been
  /// calibrated.
  final int detectedAvatarCount;

  AvatarDetectorState copyWith({
    AvatarDetectorStatus? status,
    Avatar? avatar,
    DateTime? lastAvatarDetection,
    int? detectedAvatarCount,
  }) {
    return AvatarDetectorState(
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
      lastAvatarDetection: lastAvatarDetection ?? this.lastAvatarDetection,
      detectedAvatarCount: detectedAvatarCount ?? this.detectedAvatarCount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        avatar,
        lastAvatarDetection,
        detectedAvatarCount,
      ];
}
