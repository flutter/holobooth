import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'multiple_capture_event.dart';
part 'multiple_capture_state.dart';

class MultipleCaptureBloc
    extends Bloc<MultipleCaptureEvent, MultipleCaptureState> {
  MultipleCaptureBloc() : super(MultipleCaptureState.empty()) {
    on<MultipleCaptureOnPhotoTaken>(_onPhotoTaken);
  }

  FutureOr<void> _onPhotoTaken(
    MultipleCaptureOnPhotoTaken event,
    Emitter<MultipleCaptureState> emit,
  ) {
    emit(
      state.copyWith(
        images: UnmodifiableListView([...state.images, event.image]),
      ),
    );
  }
}
