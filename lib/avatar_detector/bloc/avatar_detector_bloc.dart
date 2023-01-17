import 'dart:async';

import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

part 'avatar_detector_event.dart';
part 'avatar_detector_state.dart';

class AvatarDetectorBloc
    extends Bloc<AvatarDetectorEvent, AvatarDetectorState> {
  AvatarDetectorBloc(this._avatarDetectorRepository)
      : super(const AvatarDetectorState()) {
    on<AvatarDetectorInitialized>(_initialized);
    on<AvatarDetectorEstimateRequested>(_estimateRequested);
  }
  final AvatarDetectorRepository _avatarDetectorRepository;

  /// The time to wait before considering the [Avatar] as not detected in the
  /// next estimation.
  @visibleForTesting
  static const undetectedDelay = Duration(seconds: 2);

  /// The number of [CameraImage]s with a detected [Avatar] required before
  /// an [Avatar] is detected.
  ///
  /// It needs to warm up to calibrate a person's face geometric data.
  @visibleForTesting
  static const warmingUpImages = 10;

  /// The last time the [Avatar] was detected.
  ///
  /// Initially set to [DateTime.now] after the model is [_initialized]; then
  /// set to [DateTime.now] after every [Avatar] detection.
  ///
  /// Used to determine if the [Avatar] has been detected for a certain amount
  /// of time, which is given by [undetectedDelay].

  /// The number of [CameraImage]s with an [Avatar].
  ///
  /// The count stops at [warmingUpImages].
  ///
  /// Used to determine if the face geometric data of a person has been
  /// calibrated.
  int _detectedAvatarCount = 0;

  @override
  Future<void> close() {
    _avatarDetectorRepository.dispose();
    return super.close();
  }

  Future<FutureOr<void>> _initialized(
    AvatarDetectorInitialized event,
    Emitter<AvatarDetectorState> emit,
  ) async {
    emit(
      state.copyWith(status: AvatarDetectorStatus.loading),
    );

    try {
      await _avatarDetectorRepository.preloadLandmarksModel();
      emit(
        state.copyWith(
          status: AvatarDetectorStatus.loaded,
          lastAvatarDetection: DateTime.now(),
        ),
      );
    } on Exception catch (error, trace) {
      addError(error, trace);
      emit(
        state.copyWith(status: AvatarDetectorStatus.error),
      );
    }
  }

  Future<void> _estimateRequested(
    AvatarDetectorEstimateRequested event,
    Emitter<AvatarDetectorState> emit,
  ) async {
    if (!state.status.hasLoadedModel) return;
    emit(
      state.copyWith(status: AvatarDetectorStatus.estimating),
    );

    final imageData = tf.ImageData(
      bytes: event.input.planes.first.bytes,
      size: tf.Size(event.input.width, event.input.height),
    );
    try {
      final avatar = await _avatarDetectorRepository.detectAvatar(imageData);
      final avatarDetected = avatar != null;

      if (avatarDetected) {
        final hasWarmedUp = _detectedAvatarCount >= warmingUpImages;
        if (!hasWarmedUp) {
          _detectedAvatarCount++;
        }

        emit(
          state.copyWith(
            status: hasWarmedUp
                ? AvatarDetectorStatus.detected
                : AvatarDetectorStatus.warming,
            avatar: avatar,
            lastAvatarDetection: DateTime.now(),
          ),
        );
      } else {
        if (DateTime.now().difference(state.lastAvatarDetection!) >
            undetectedDelay) {
          emit(
            state.copyWith(status: AvatarDetectorStatus.notDetected),
          );
        }
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(status: AvatarDetectorStatus.error),
      );
    }
  }
}
