import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:screen_recorder/screen_recorder.dart';

part 'convert_event.dart';
part 'convert_state.dart';

class ConvertBloc extends Bloc<ConvertEvent, ConvertState> {
  ConvertBloc({
    required ConvertRepository convertRepository,
  })  : _convertRepository = convertRepository,
        super(const ConvertState()) {
    on<GenerateVideoRequested>(_generateVideo);
    on<ProcessFramesRequested>(_processFramesRequested);
    on<ShareRequested>(_shareRequested);
  }

  final ConvertRepository _convertRepository;

  FutureOr<void> _generateVideo(
    GenerateVideoRequested event,
    Emitter<ConvertState> emit,
  ) async {
    if (state.maxTriesReached) return;
    emit(state.copyWith(status: ConvertStatus.creatingVideo));

    try {
      final result =
          await _convertRepository.generateVideo(state.framesProcessed);
      final isWaitingForVideo = state.shareStatus == ShareStatus.waiting;
      emit(
        state.copyWith(
          videoPath: result.videoUrl,
          gifPath: result.gifUrl,
          status: ConvertStatus.videoCreated,
          firstFrameProcessed: result.firstFrame,
          twitterShareUrl: result.twitterShareUrl,
          triesCount: 0,
          shareStatus:
              isWaitingForVideo ? ShareStatus.success : ShareStatus.initial,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          status: ConvertStatus.error,
          triesCount: state.triesCount + 1,
        ),
      );
    }
  }

  Future<FutureOr<void>> _processFramesRequested(
    ProcessFramesRequested event,
    Emitter<ConvertState> emit,
  ) async {
    emit(state.copyWith(status: ConvertStatus.loadingFrames));
    final framesAsImages = event.frames.map((e) => e.image).toList();
    final frames = await _convertRepository.processFrames(framesAsImages);
    emit(
      state.copyWith(
        status: ConvertStatus.loadedFrames,
        framesProcessed: frames,
      ),
    );
  }

  FutureOr<void> _shareRequested(
    ShareRequested event,
    Emitter<ConvertState> emit,
  ) {
    if (state.status == ConvertStatus.creatingVideo) {
      emit(
        state.copyWith(
          shareStatus: ShareStatus.waiting,
        ),
      );
    } else {
      emit(
        state.copyWith(
          shareStatus: ShareStatus.success,
        ),
      );
    }
  }
}
