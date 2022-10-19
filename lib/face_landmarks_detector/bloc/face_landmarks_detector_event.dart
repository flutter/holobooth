part of 'face_landmarks_detector_bloc.dart';

abstract class FaceLandmarksDetectorEvent extends Equatable {
  const FaceLandmarksDetectorEvent();
}

class FaceLandmarksDetectorInitialized extends FaceLandmarksDetectorEvent {
  const FaceLandmarksDetectorInitialized();

  @override
  List<Object> get props => [];
}

class FaceLandmarksDetectorEstimateRequested
    extends FaceLandmarksDetectorEvent {
  const FaceLandmarksDetectorEstimateRequested(this.input);

  final CameraImage input;

  @override
  List<Object> get props => [input];
}
