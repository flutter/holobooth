part of 'camera_bloc.dart';

class HoloboothCameraState extends Equatable {
  const HoloboothCameraState({this.camera});

  final CameraDescription? camera;

  @override
  List<Object?> get props => [camera];
}
