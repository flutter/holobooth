import 'dart:async';

import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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

  /// The time to wait before considering the avatar as not detected.
  @visibleForTesting
  static const undectedDelay = Duration(seconds: 2);

  /// The last time the avatar was detected.
  late DateTime _lastAvatarDetection;

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
        state.copyWith(status: AvatarDetectorStatus.loaded),
      );
      _lastAvatarDetection = DateTime.now();
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
      if (avatar == null) {
        if (DateTime.now().difference(_lastAvatarDetection) > undectedDelay) {
          emit(
            state.copyWith(status: AvatarDetectorStatus.notDetected),
          );
        }
      } else {
        emit(
          state.copyWith(
            status: AvatarDetectorStatus.detected,
            avatar: avatar,
          ),
        );
        _lastAvatarDetection = DateTime.now();
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(status: AvatarDetectorStatus.error),
      );
    }
  }
}
