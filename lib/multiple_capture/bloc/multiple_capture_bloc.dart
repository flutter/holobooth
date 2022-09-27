import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'multiple_capture_event.dart';
part 'multiple_capture_state.dart';

class MultipleCaptureBloc
    extends Bloc<MultipleCaptureEvent, MultipleCaptureState> {
  MultipleCaptureBloc() : super(const MultipleCaptureState()) {
    on<MultipleCapturePhotoTaken>(_requested);
  }

  FutureOr<void> _requested(
    MultipleCapturePhotoTaken event,
    Emitter<MultipleCaptureState> emit,
  ) {
    final newImages = [...state.images, event.image];
    emit(
      state.copyWith(images: newImages),
    );
  }
}
