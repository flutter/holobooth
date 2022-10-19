part of 'avatar_detector_bloc.dart';

abstract class AvatarDetectorEvent extends Equatable {
  const AvatarDetectorEvent();
}

class AvatarDetectorInitialized extends AvatarDetectorEvent {
  const AvatarDetectorInitialized();

  @override
  List<Object> get props => [];
}

class AvatarDetectorEstimateRequested extends AvatarDetectorEvent {
  const AvatarDetectorEstimateRequested(this.input);

  final CameraImage input;

  @override
  List<Object> get props => [input];
}
