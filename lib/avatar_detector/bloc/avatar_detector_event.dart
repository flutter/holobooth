part of 'avatar_detector_bloc.dart';

abstract class AvatarDetectorEvent extends Equatable {
  const AvatarDetectorEvent();
  @override
  List<Object> get props => [];
}

class AvatarDetectorInitialized extends AvatarDetectorEvent {
  const AvatarDetectorInitialized();
}

class AvatarDetectorEstimateRequested extends AvatarDetectorEvent {
  const AvatarDetectorEstimateRequested(this.input);

  final CameraImage input;

  @override
  List<Object> get props => [input];
}
