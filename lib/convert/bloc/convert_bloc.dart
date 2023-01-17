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
  }

  final ConvertRepository _convertRepository;

  FutureOr<void> _generateVideo(
    GenerateVideoRequested event,
    Emitter<ConvertState> emit,
  ) async {
    if (state.maxTriesReached) return;
    emit(state.copyWith(status: ConvertStatus.creatingVideo));
    if (event.frames != null) {
      final frames = event.frames!.map((e) => e.image).toList();
      emit(state.copyWith(frames: frames));
    }

    try {
      final result = await _convertRepository.generateVideo(state.frames);
      emit(
        state.copyWith(
          videoPath: result.videoUrl,
          gifPath: result.gifUrl,
          status: ConvertStatus.videoCreated,
          firstFrameProcessed: result.firstFrame,
          twitterShareUrl: result.twitterShareUrl,
          triesCount: 0,
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
}
