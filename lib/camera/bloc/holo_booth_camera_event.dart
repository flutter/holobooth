part of 'camera_bloc.dart';

abstract class HoloboothCameraEvent extends Equatable {
  const HoloboothCameraEvent();
}

class CameraChanged extends HoloboothCameraEvent {
  const CameraChanged(this.camera);

  final CameraDescription? camera;

  @override
  List<Object?> get props => [camera];
}
