import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

part 'camera_event.dart';

part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(const CameraState()) {
    on<CameraStarted>(_onCameraStarted);
    on<CameraChanged>(_onCameraChangedEvent);
  }

  FutureOr<void> _onCameraStarted(
    CameraStarted event,
    Emitter<CameraState> emit,
  ) async {
    if (state.availableCameras != null) {
      return;
    }

    try {
      final cameras = await availableCameras();
      emit(
        CameraState(
          availableCameras: cameras,
          camera: cameras.isNotEmpty ? cameras[0] : null,
        ),
      );
    } catch (error) {
      emit(CameraState(cameraError: error));
    }
  }

  FutureOr<void> _onCameraChangedEvent(
    CameraChanged event,
    Emitter<CameraState> emit,
  ) {
    emit(state.copyWith(camera: event.camera));
  }
}
