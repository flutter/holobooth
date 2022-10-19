part of 'avatar_detector_bloc.dart';

abstract class AvatarDetectorState {
  const AvatarDetectorState();
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

class AvatarDetectorFacesDetected extends AvatarDetectorState {
  AvatarDetectorFacesDetected(this.face);

  tf.Face face;
}
