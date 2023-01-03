import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:screen_recorder/screen_recorder.dart';

part 'photo_booth_event.dart';
part 'photo_booth_state.dart';

class PhotoBoothBloc extends Bloc<PhotoBoothEvent, PhotoBoothState> {
  PhotoBoothBloc() : super(const PhotoBoothState()) {
    on<PhotoBoothGetReadyStarted>(_getReadyStarted);
    on<PhotoBoothRecordingStarted>(_recordingStarted);
    on<PhotoBoothRecordingFinished>(_recordingFinished);
  }

  FutureOr<void> _getReadyStarted(
    PhotoBoothGetReadyStarted event,
    Emitter<PhotoBoothState> emit,
  ) {
    emit(
      state.copyWith(gettingReady: true),
    );
  }

  FutureOr<void> _recordingStarted(
    PhotoBoothRecordingStarted event,
    Emitter<PhotoBoothState> emit,
  ) {
    emit(
      state.copyWith(
        isRecording: true,
        gettingReady: false,
      ),
    );
  }

  FutureOr<void> _recordingFinished(
    PhotoBoothRecordingFinished event,
    Emitter<PhotoBoothState> emit,
  ) {
    emit(
      state.copyWith(
        frames: UnmodifiableListView(event.frames),
        isRecording: false,
      ),
    );
  }
}
