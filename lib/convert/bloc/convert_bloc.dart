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
    on<GenerateVideo>(_generateVideo);
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
      emit(state.copyWith(status: ConvertStatus.loadingFrames));
      final totalFramesToProcess = event.frames.length;
      final processedFrames = <Uint8List>[];
      var batchIndex = 0;

      for (var i = 0; i < totalFramesToProcess; i++) {
        final bytesImage =
            await event.frames[i].image.toByteData(format: ImageByteFormat.png);
        if (bytesImage != null) {
          processedFrames.add(bytesImage.buffer.asUint8List());
        }
        batchIndex++;
        if (batchIndex == _maxBatchSize) {
          final progress = _normalizeProgress(
            processedFrames.length,
            0,
            totalFramesToProcess,
          );

          await Future<void>.delayed(const Duration(milliseconds: 100));
          emit(state.copyWith(progress: progress));
          batchIndex = 0;
        }
      }
      emit(
        state.copyWith(
          status: ConvertStatus.framesProcessed,
          processedFrames: processedFrames,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(state.copyWith(status: ConvertStatus.error));
    }
  }

  Future<void> _generateVideo(
    GenerateVideo event,
    Emitter<ConvertState> emit,
  ) async {
    emit(state.copyWith(status: ConvertStatus.creatingVideo));
    try {
      final result = await _convertRepository.convertFrames(
        state.processedFrames,
      );
      emit(
        state.copyWith(
          videoPath: result.videoUrl,
          gifPath: result.gifUrl,
          status: ConvertStatus.videoCreated,
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
}
