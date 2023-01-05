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
    on<ConvertFrames>(_convertFrames);
    on<FinishConvert>(_finishConvert);
  }

  final ConvertRepository _convertRepository;
  double _normalizeProgress(int value, int min, int max) {
    return (value - min) / (max - min);
  }

  static const _maxBatchSize = 5;

  FutureOr<void> _convertFrames(
    ConvertFrames event,
    Emitter<ConvertState> emit,
  ) async {
    try {
      final totalFrames = event.frames.length;
      emit(state.copyWith(status: ConvertStatus.loadingFrames));

      final processedFrames = <Uint8List>[];
      var batchIndex = 0;

      for (var i = 0; i < totalFrames; i++) {
        final bytesImage =
            await event.frames[i].image.toByteData(format: ImageByteFormat.png);
        if (bytesImage != null) {
          processedFrames.add(bytesImage.buffer.asUint8List());
          if (i == 0) {
            emit(state.copyWith(firstFrame: bytesImage));
          }
        }
        batchIndex++;
        if (batchIndex == _maxBatchSize) {
          final framesProcessed = state.framesProcessed + _maxBatchSize;
          final progress = _normalizeProgress(framesProcessed, 0, totalFrames);
          emit(
            state.copyWith(
              framesProcessed: framesProcessed,
              progress: progress,
            ),
          );
          await Future<void>.delayed(const Duration(milliseconds: 100));
          batchIndex = 0;
        }
      }

      emit(state.copyWith(status: ConvertStatus.loadingVideo));
      final result = await _convertRepository.convertFrames(processedFrames);
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
