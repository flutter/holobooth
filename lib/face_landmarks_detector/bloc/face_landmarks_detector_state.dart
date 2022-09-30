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
  const FaceLandmarksDetectorLoaded(this.faceLandmarksDetector);

  final tf.FaceLandmarksDetector faceLandmarksDetector;

  @override
  List<Object> get props => [faceLandmarksDetector];
}

class FaceLandmarksDetectorEstimating extends FaceLandmarksDetectorLoaded {
  const FaceLandmarksDetectorEstimating(super.faceLandmarksDetector);
}

class FaceLandmarksDetectorFacesDetected extends FaceLandmarksDetectorLoaded {
  const FaceLandmarksDetectorFacesDetected(
    this.faces,
    super.faceLandmarksDetector,
  );

  final tf.Faces faces;

  @override
  List<Object> get props => [faces, faceLandmarksDetector];
}
