import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'photo_booth_event.dart';
part 'photo_booth_state.dart';

class PhotoBoothBloc extends Bloc<PhotoBoothEvent, PhotoBoothState> {
  PhotoBoothBloc() : super(PhotoBoothState.empty()) {
    on<PhotoBoothOnPhotoTaken>(_onPhotoTaken);
    on<PhotoBoothRecordingStarted>(_countdownStarted);
    on<PhotoBoothRecordingFinished>(_countdownFinished);
  }

  FutureOr<void> _onPhotoTaken(
    PhotoBoothOnPhotoTaken event,
    Emitter<PhotoBoothState> emit,
  ) {
    emit(
      state.copyWith(
        images: UnmodifiableListView([...state.images, event.image]),
      ),
    );
  }

  FutureOr<void> _countdownStarted(
    PhotoBoothRecordingStarted event,
    Emitter<PhotoBoothState> emit,
  ) {
    // TODO(oscar): start recording
  }

  FutureOr<void> _countdownFinished(
    PhotoBoothRecordingFinished event,
    Emitter<PhotoBoothState> emit,
  ) {
    // TODO(oscar): stop recording
  }
}
