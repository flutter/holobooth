part of 'avatar_detector_bloc.dart';

abstract class AvatarDetectorState {
  const AvatarDetectorState();
}

class FaceLandmarksDetectorInitial extends AvatarDetectorState {}

class FaceLandmarksDetectorLoading extends AvatarDetectorState {}

class FaceLandmarksDetectorError extends AvatarDetectorState {}

class FaceLandmarksDetectorLoaded extends AvatarDetectorState {
  const FaceLandmarksDetectorLoaded();
}

class FaceLandmarksDetectorEstimating extends AvatarDetectorState {
  const FaceLandmarksDetectorEstimating();
}

class FaceLandmarksDetectorFacesDetected extends AvatarDetectorState {
  FaceLandmarksDetectorFacesDetected(
    this.face,
  );

  tf.Face face;
}
