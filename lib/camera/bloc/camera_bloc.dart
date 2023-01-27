import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

part 'holo_booth_camera_event.dart';

part 'holo_booth_camera_state.dart';

class CameraBloc extends Bloc<HoloboothCameraEvent, HoloboothCameraState> {
  CameraBloc() : super(const HoloboothCameraState()) {
    on<CameraChanged>(_onCameraChangedEvent);
  }

  FutureOr<void> _onCameraChangedEvent(
      CameraChanged event, Emitter<HoloboothCameraState> emit) {
    emit(state.copyWith(camera: event.camera));
  }
}
