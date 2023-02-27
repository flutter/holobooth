part of 'camera_bloc.dart';

class CameraState extends Equatable {
  const CameraState({
    this.camera,
    this.availableCameras,
    this.cameraError,
  });

  final CameraDescription? camera;
  final List<CameraDescription>? availableCameras;
  final Object? cameraError;

  CameraState copyWith({
    CameraDescription? camera,
    List<CameraDescription>? availableCameras,
    Object? cameraError,
  }) {
    return CameraState(
      camera: camera ?? this.camera,
      availableCameras: availableCameras ?? this.availableCameras,
      cameraError: cameraError ?? this.cameraError,
    );
  }

  @override
  List<Object?> get props => [camera, availableCameras, cameraError];
}
