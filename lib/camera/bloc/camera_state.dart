part of 'camera_bloc.dart';

class CameraState extends Equatable {
  const CameraState({this.camera});

  final CameraDescription? camera;

  @override
  List<Object?> get props => [camera];
}
