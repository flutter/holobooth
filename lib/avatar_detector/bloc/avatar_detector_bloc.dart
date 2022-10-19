import 'dart:async';

import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

part 'avatar_detector_event.dart';
part 'avatar_detector_state.dart';

class AvatarDetectorBloc
    extends Bloc<AvatarDetectorEvent, AvatarDetectorState> {
  AvatarDetectorBloc(this._avatarDetectorRepository)
      : super(AvatarDetectorInitial()) {
    on<AvatarDetectorInitialized>(_initialized);
    on<AvatarDetectorEstimateRequested>(_estimateRequested);
  }
  final AvatarDetectorRepository _avatarDetectorRepository;

  @override
  Future<void> close() {
    _avatarDetectorRepository.dispose();
    return super.close();
  }

  Future<FutureOr<void>> _initialized(
    AvatarDetectorInitialized event,
    Emitter<AvatarDetectorState> emit,
  ) async {
    emit(AvatarDetectorLoading());
    try {
      await _avatarDetectorRepository.preloadLandmarksModel();
      emit(const AvatarDetectorLoaded());
    } on Exception catch (error, trace) {
      addError(error, trace);
      emit(AvatarDetectorError());
    }
  }

  Future<void> _estimateRequested(
    AvatarDetectorEstimateRequested event,
    Emitter<AvatarDetectorState> emit,
  ) async {
    // TODO(oscar): Ensure _estimateRequested is not called when currently
    // estimating.
    if (this.state is AvatarDetectorEstimating) return;

    // The following hack allows to avoid a performance hit by reusing the
    // object. This is because constructing objects in Dart is expensive and
    // impacts the performance heavily when done repeatedly inside a loop.
    final state = this.state is AvatarDetectorFacesDetected
        ? this.state as AvatarDetectorFacesDetected
        : AvatarDetectorFacesDetected(tf.Face.empty());
    emit(const AvatarDetectorEstimating());
    final imageData = tf.ImageData(
      bytes: event.input.planes.first.bytes,
      size: tf.Size(event.input.width, event.input.height),
    );
    final face = await _avatarDetectorRepository.detectFace(imageData);
    if (face == null) {
      emit(AvatarDetectorFacesDetected(tf.Face.empty()));
    } else {
      emit(state..face = face);
    }
  }
}
