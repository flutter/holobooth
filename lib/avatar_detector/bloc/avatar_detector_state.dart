part of 'avatar_detector_bloc.dart';

abstract class AvatarDetectorState extends Equatable {
  const AvatarDetectorState();
  @override
  List<Object?> get props => [];
}

class AvatarDetectorInitial extends AvatarDetectorState {}

class AvatarDetectorLoading extends AvatarDetectorState {}

class AvatarDetectorError extends AvatarDetectorState {}

class AvatarDetectorLoaded extends AvatarDetectorState {
  const AvatarDetectorLoaded();
}

class AvatarDetectorEstimating extends AvatarDetectorState {
  const AvatarDetectorEstimating();
}

class AvatarDetectorFaceDetected extends AvatarDetectorState {
  const AvatarDetectorFaceDetected(this.face);

  final tf.Face face;

  @override
  List<Object?> get props => [face];
}

class AvatarDetectorFaceNotDetected extends AvatarDetectorState {
  const AvatarDetectorFaceNotDetected();
}
