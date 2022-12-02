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
    on<PhotoBoothCountdownStarted>(_countdownStarted);
    on<PhotoBoothCountdownFinished>(_countdownFinished);
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
      PhotoBoothCountdownStarted event, Emitter<PhotoBoothState> emit) {}

  FutureOr<void> _countdownFinished(
      PhotoBoothCountdownFinished event, Emitter<PhotoBoothState> emit) {}
}
