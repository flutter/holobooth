part of 'avatar_detector_bloc.dart';

abstract class AvatarDetectorEvent extends Equatable {
  const AvatarDetectorEvent();
}

class FaceLandmarksDetectorInitialized extends AvatarDetectorEvent {
  const FaceLandmarksDetectorInitialized();

  @override
  List<Object> get props => [];
}

class FaceLandmarksDetectorEstimateRequested extends AvatarDetectorEvent {
  const FaceLandmarksDetectorEstimateRequested(this.input);

  final CameraImage input;

  @override
  List<Object> get props => [input];
}
