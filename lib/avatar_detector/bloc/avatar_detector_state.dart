part of 'avatar_detector_bloc.dart';

abstract class AvatarDetectorState extends Equatable {
  const AvatarDetectorState();
  @override
  List<Object?> get props => [];
}

class AvatarDetectorInitial extends AvatarDetectorState {
  const AvatarDetectorInitial();
}

class AvatarDetectorLoading extends AvatarDetectorState {
  const AvatarDetectorLoading();
}

class AvatarDetectorError extends AvatarDetectorState {
  const AvatarDetectorError();
}

class AvatarDetectorLoaded extends AvatarDetectorState {
  const AvatarDetectorLoaded();
}

class AvatarDetectorEstimating extends AvatarDetectorState {
  const AvatarDetectorEstimating();
}

class AvatarDetectorFaceDetected extends AvatarDetectorState {
  const AvatarDetectorFaceDetected(this.avatar);

  final Avatar avatar;

  @override
  List<Object?> get props => [avatar];
}

class AvatarDetectorFaceNotDetected extends AvatarDetectorState {
  const AvatarDetectorFaceNotDetected();
}
