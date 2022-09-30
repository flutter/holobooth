part of 'face_landmarks_detector_bloc.dart';

abstract class FaceLandmarksDetectorState extends Equatable {
  const FaceLandmarksDetectorState();

  @override
  List<Object> get props => [];
}

class FaceLandmarksDetectorInitial extends FaceLandmarksDetectorState {}

class FaceLandmarksDetectorLoading extends FaceLandmarksDetectorState {}

class FaceLandmarksDetectorError extends FaceLandmarksDetectorState {}

class FaceLandmarksDetectorLoaded extends FaceLandmarksDetectorState {
  const FaceLandmarksDetectorLoaded();

  @override
  List<Object> get props => [];
}

class FaceLandmarksDetectorEstimating extends FaceLandmarksDetectorLoaded {
  const FaceLandmarksDetectorEstimating();
}

class FaceLandmarksDetectorFacesDetected extends FaceLandmarksDetectorLoaded {
  FaceLandmarksDetectorFacesDetected(
    this.faces,
  );

  tf.Faces faces;

  @override
  List<Object> get props => [faces];
}
