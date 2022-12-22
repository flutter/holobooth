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
        super(const ConvertState.initial()) {
    on<ConvertFrames>(_convertFrames);
    on<FinishConvert>(_finishConvert);
  }

  final ConvertRepository _convertRepository;

  FutureOr<void> _convertFrames(
    ConvertFrames event,
    Emitter<ConvertState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          frames: event.frames,
          status: ConvertStatus.loading,
        ),
      );

      final frames = <Uint8List>[];
      for (final frame in event.frames) {
        frames.add(frame.image.buffer.asUint8List());
      }
      final result = await _convertRepository.convertFrames(frames);

      emit(
        state.copyWith(
          videoPath: result.videoUrl,
          gifPath: result.gifUrl,
          status: ConvertStatus.success,
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
  }

  FutureOr<void> _finishConvert(
    FinishConvert event,
    Emitter<ConvertState> emit,
  ) async {
    emit(
      state.copyWith(
        isFinished: true,
      ),
    );
  }
}
