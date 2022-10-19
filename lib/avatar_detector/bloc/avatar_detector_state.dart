part of 'avatar_detector_bloc.dart';

abstract class AvatarDetectorState extends Equatable {
  const AvatarDetectorState();
}

class AvatarDetectorInitial extends AvatarDetectorState {
  @override
  List<Object?> get props => [];
}

class AvatarDetectorLoading extends AvatarDetectorState {
  @override
  List<Object?> get props => [];
}

class AvatarDetectorError extends AvatarDetectorState {
  @override
  List<Object?> get props => [];
}

class AvatarDetectorLoaded extends AvatarDetectorState {
  const AvatarDetectorLoaded();

  @override
  List<Object?> get props => [];
}

class AvatarDetectorEstimating extends AvatarDetectorState {
  const AvatarDetectorEstimating();
  @override
  List<Object?> get props => [];
}

class AvatarDetectorFaceDetected extends AvatarDetectorState {
  const AvatarDetectorFaceDetected(this.face);

  final tf.Face face;

  @override
  List<Object?> get props => [face];
}

class AvatarDetectorFaceNotDetected extends AvatarDetectorState {
  const AvatarDetectorFaceNotDetected();

  @override
  List<Object> get props => [];
}
