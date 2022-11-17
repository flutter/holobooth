part of 'avatar_detector_bloc.dart';

enum AvatarDetectorStatus {
  initial,
  loading,
  loaded,
  error,
  estimating,
  detected,
  notDetected;

  bool get hasLoadedModel =>
      this == loaded ||
      this == estimating ||
      this == detected ||
      this == notDetected;
}

class AvatarDetectorState extends Equatable {
  const AvatarDetectorState({
    this.status = AvatarDetectorStatus.initial,
    this.avatar = Avatar.zero,
  });

  final AvatarDetectorStatus status;
  final Avatar avatar;

  AvatarDetectorState copyWith({
    AvatarDetectorStatus? status,
    Avatar? avatar,
  }) {
    return AvatarDetectorState(
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  List<Object> get props => [status, avatar];
}
