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
        super(ConvertInitial()) {
    on<ConvertFrames>(_convertFrames);
  }

  final ConvertRepository _convertRepository;

  FutureOr<void> _convertFrames(
    ConvertFrames event,
    Emitter<ConvertState> emit,
  ) async {
    try {
      emit(ConvertLoading());

      final frames = <Uint8List>[];
      for (final frame in event.frames) {
        frames.add(frame.image.buffer.asUint8List());
      }
      final videoPath = await _convertRepository.convertFrames(frames);

      emit(ConvertSuccess(videoPath));
    } catch (error) {
      emit(ConvertError());
    }
  }
}
