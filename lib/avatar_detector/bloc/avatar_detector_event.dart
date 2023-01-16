part of 'avatar_detector_bloc.dart';

abstract class AvatarDetectorEvent extends Equatable {
  const AvatarDetectorEvent();
  @override
  List<Object> get props => [];
}

/// Initializes the [AvatarDetectorBloc].
///
/// It should be called once when the [AvatarDetectorBloc] is created to load
/// the tensorflow model.
class AvatarDetectorInitialized extends AvatarDetectorEvent {
  const AvatarDetectorInitialized();
}

/// Requests an estimate of the [Avatar] from the [CameraImage].
///
/// It should be called every time a new [CameraImage] is available.
///
/// Does nothing if the tensorflow model has not been initialized.
class AvatarDetectorEstimateRequested extends AvatarDetectorEvent {
  const AvatarDetectorEstimateRequested(this.input);

  final CameraImage input;

  @override
  List<Object> get props => [input];
}
