import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'multiple_capture_event.dart';
part 'multiple_capture_state.dart';

class MultipleCaptureBloc
    extends Bloc<MultipleCaptureEvent, MultipleCaptureState> {
  MultipleCaptureBloc() : super(MultipleCaptureState.empty()) {
    on<MultipleCapturePhotoTaken>(_photoTaken);
  }

  FutureOr<void> _photoTaken(
    MultipleCapturePhotoTaken event,
    Emitter<MultipleCaptureState> emit,
  ) {
    emit(
      state.copyWith(
        images: UnmodifiableListView([...state.images, event.image]),
      ),
    );
  }
}
