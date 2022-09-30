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
    on<FaceLandmarksDetectorEstimateRequested>(
      _estimateRequested,
    );
  }
  late final tf.FaceLandmarksDetector _detector;

  @override
  Future<void> close() {
    _detector.dispose();
    return super.close();
  }

  Future<FutureOr<void>> _initialized(
    FaceLandmarksDetectorInitialized event,
    Emitter<FaceLandmarksDetectorState> emit,
  ) async {
    emit(FaceLandmarksDetectorLoading());
    try {
      _detector = await tf.TensorFlowFaceLandmarks.load();
      emit(const FaceLandmarksDetectorLoaded());
    } on Exception catch (error, trace) {
      addError(error, trace);
    }
  }

  Future<void> _estimateRequested(
    FaceLandmarksDetectorEstimateRequested event,
    Emitter<FaceLandmarksDetectorState> emit,
  ) async {
    assert(
      this.state is FaceLandmarksDetectorLoaded,
      "Can't estimate without initializing, make sure to "
      'add $FaceLandmarksDetectorInitialized.',
    );
    // TODO(oscar): Ensure _estimateRequested is not called when currently
    // estimating.
    if (this.state is FaceLandmarksDetectorEstimating) return;

    // The following hack allows to avoid a performance hit by reusing the
    // object. This is because constructing objects in Dart is expensive and
    // impacts the performance heavily when done repeatedly inside a loop.
    final state = this.state is FaceLandmarksDetectorFacesDetected
        ? this.state as FaceLandmarksDetectorFacesDetected
        : FaceLandmarksDetectorFacesDetected(const []);
    emit(const FaceLandmarksDetectorEstimating());
    final faces = await _detector.estimateFaces(event.input);
    emit(state..faces = faces);
  }
}
