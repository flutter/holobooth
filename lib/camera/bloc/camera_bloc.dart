import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

part 'camera_event.dart';

part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(const CameraState()) {
    on<CameraChanged>(_onCameraChangedEvent);
  }

  FutureOr<void> _onCameraChangedEvent(
    CameraChanged event,
    Emitter<CameraState> emit,
  ) {
    emit(CameraState(camera: event.camera));
  }
}
