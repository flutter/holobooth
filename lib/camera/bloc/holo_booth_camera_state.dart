part of 'camera_bloc.dart';

class HoloboothCameraState extends Equatable {
  const HoloboothCameraState({this.camera});

  final CameraDescription? camera;

  HoloboothCameraState copyWith({
    CameraDescription? camera,
  }) {
    return HoloboothCameraState(
      camera: camera ?? this.camera,
    );
  }

  @override
  List<Object?> get props => [camera];
}
