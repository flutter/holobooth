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
  final processedFrames = <Uint8List>[];

  Future<Uint8List?> _getFrameData(Image image) async {
    final bytesImage = await image.toByteData(format: ImageByteFormat.png);
    return bytesImage?.buffer.asUint8List();
  }

  Future<void> _processFrames(List<Frame> frames) async {
    final bytesImage = await Future.delayed(
      const Duration(milliseconds: 10),
      () => _getFrameData(frames[state.processedFrames.length + 1].image),
    );

    if (bytesImage != null) {
      processedFrames.add(bytesImage);
    }
    if (processedFrames.length == frames.length) return;
    await _processFrames(frames);
  }

  FutureOr<void> _convertFrames(
    ConvertFrames event,
    Emitter<ConvertState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ConvertStatus.loadingFrames));
      //1
      //await _processFrames(event.frames);
      //2
      final totalFramesToProcess = event.frames.length;
      for (var i = 0; i < totalFramesToProcess; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 16));
        final bytesImage =
            await event.frames[i].image.toByteData(format: ImageByteFormat.png);
        if (bytesImage != null) {
          processedFrames.add(bytesImage.buffer.asUint8List());
        }
      }
      //

      emit(
        state.copyWith(
          status: ConvertStatus.framesProcessed,
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
        processedFrames,
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
