import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

part 'face_landmarks_detector_event.dart';
part 'face_landmarks_detector_state.dart';

class FaceLandmarksDetectorBloc
    extends Bloc<FaceLandmarksDetectorEvent, FaceLandmarksDetectorState> {
  FaceLandmarksDetectorBloc() : super(FaceLandmarksDetectorInitial()) {
    on<FaceLandmarksDetectorInitialized>(_initialized);
    on<FaceLandmarksDetectorEstimateRequested>(_estimateRequested);
  }

  Future<FutureOr<void>> _initialized(
    FaceLandmarksDetectorInitialized event,
    Emitter<FaceLandmarksDetectorState> emit,
  ) async {
    emit(FaceLandmarksDetectorLoading());
    try {
      final detector = await tf.TensorFlowFaceLandmarks.load();
      emit(FaceLandmarksDetectorLoaded(detector));
    } on Exception catch (error, trace) {
      addError(error, trace);
    }
  }

  Future<FutureOr<void>> _estimateRequested(
    FaceLandmarksDetectorEstimateRequested event,
    Emitter<FaceLandmarksDetectorState> emit,
  ) async {
    assert(this.state is FaceLandmarksDetectorLoaded, 'whatever');
    final state = this.state as FaceLandmarksDetectorLoaded;
    emit(
      FaceLandmarksDetectorEstimating(state.faceLandmarksDetector),
    );
    final faces = await state.faceLandmarksDetector.estimateFaces(event.input);
    emit(
      FaceLandmarksDetectorFacesDetected(
        faces,
        state.faceLandmarksDetector,
      ),
    );
  }
}
