part of 'camera_bloc.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();
}

class CameraStarted extends CameraEvent {
  @override
  List<Object?> get props => [];
}

class CameraChanged extends CameraEvent {
  const CameraChanged(this.camera);

  final CameraDescription camera;

  @override
  List<Object?> get props => [camera];
}
