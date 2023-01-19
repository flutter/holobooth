import 'dart:async';

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
    required List<Frame> frames,
  })  : _convertRepository = convertRepository,
        _frames = frames,
        super(const ConvertState()) {
    on<GenerateVideoRequested>(_generateVideoRequested);
    on<ShareRequested>(_shareRequested);
    on<GenerateFramesRequested>(_generateFramesRequested);
  }

  final ConvertRepository _convertRepository;
  final List<Frame> _frames;

  Future<void> _generateFramesRequested(
    GenerateFramesRequested event,
    Emitter<ConvertState> emit,
  ) async {
    emit(state.copyWith(status: ConvertStatus.loadingFrames));
    try {
      final framesAsImages = _frames.map((e) => e.image).toList();
      final framesProcessed =
          await _convertRepository.processFrames(framesAsImages);
      emit(
        state.copyWith(
          status: ConvertStatus.loadedFrames,
          firstFrameProcessed: framesProcessed.first,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          status: ConvertStatus.errorLoadingFrames,
          triesCount: state.triesCount + 1,
        ),
      );
    }
  }

  Future<void> _generateVideoRequested(
    GenerateVideoRequested event,
    Emitter<ConvertState> emit,
  ) async {
    if (state.maxTriesReached) return;

    try {
      emit(state.copyWith(status: ConvertStatus.creatingVideo));

      final result = await _convertRepository.generateVideo();
      final isWaitingForVideo = state.shareStatus == ShareStatus.waiting;
      emit(
        state.copyWith(
          videoPath: result.videoUrl,
          gifPath: result.gifUrl,
          status: ConvertStatus.videoCreated,
          twitterShareUrl: result.twitterShareUrl,
          triesCount: 0,
          shareStatus:
              isWaitingForVideo ? ShareStatus.ready : ShareStatus.initial,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          status: ConvertStatus.errorGeneratingVideo,
          triesCount: state.triesCount + 1,
        ),
      );
    }
  }

  FutureOr<void> _shareRequested(
    ShareRequested event,
    Emitter<ConvertState> emit,
  ) {
    if (state.status == ConvertStatus.creatingVideo) {
      emit(
        state.copyWith(
          shareStatus: ShareStatus.waiting,
          shareType: event.shareType,
        ),
      );
    }
  }
}
