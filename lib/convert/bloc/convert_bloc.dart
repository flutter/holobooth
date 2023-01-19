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
  })  : _convertRepository = convertRepository,
        super(const ConvertState()) {
    on<GenerateVideoRequested>(_generateVideoRequested);
    on<ShareRequested>(_shareRequested);
  }

  final ConvertRepository _convertRepository;

  Future<void> _generateVideoRequested(
    GenerateVideoRequested event,
    Emitter<ConvertState> emit,
  ) async {
    if (state.maxTriesReached) return;
    emit(state.copyWith(status: ConvertStatus.loadingFrames));
    var framesProcessed = <Uint8List>[];
    try {
      final framesAsImages = event.frames.map((e) => e.image).toList();
      framesProcessed = await _convertRepository.processFrames(framesAsImages);
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
          status: ConvertStatus.error,
        ),
      );
    }

    emit(state.copyWith(status: ConvertStatus.creatingVideo));

    try {
      final result = await _convertRepository.generateVideo(framesProcessed);
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
          status: ConvertStatus.error,
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
    } else {
      emit(
        state.copyWith(
          shareStatus: ShareStatus.ready,
        ),
      );
    }
  }
}
