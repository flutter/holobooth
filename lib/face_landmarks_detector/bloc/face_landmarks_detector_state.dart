part of 'face_landmarks_detector_bloc.dart';

abstract class FaceLandmarksDetectorState {
  const FaceLandmarksDetectorState();
}

class FaceLandmarksDetectorInitial extends FaceLandmarksDetectorState {}

class FaceLandmarksDetectorLoading extends FaceLandmarksDetectorState {}

class FaceLandmarksDetectorError extends FaceLandmarksDetectorState {}

class FaceLandmarksDetectorLoaded extends FaceLandmarksDetectorState {
  const FaceLandmarksDetectorLoaded();
}

class FaceLandmarksDetectorEstimating extends FaceLandmarksDetectorState {
  const FaceLandmarksDetectorEstimating();
}

class FaceLandmarksDetectorFacesDetected extends FaceLandmarksDetectorState {
  FaceLandmarksDetectorFacesDetected(
    this.faces,
  );

  tf.Faces faces;
}
