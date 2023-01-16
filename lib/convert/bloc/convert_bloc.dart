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

  var _frames = <Image>[];

  FutureOr<void> _generateVideo(
    GenerateVideoRequested event,
    Emitter<ConvertState> emit,
  ) async {
    emit(state.copyWith(status: ConvertStatus.creatingVideo));
    if (event.frames != null) {
      _frames = event.frames!.map((e) => e.image).toList();
    }

    try {
      throw Exception();
      final result = await _convertRepository.generateVideo(_frames);
      emit(
        state.copyWith(
          videoPath: result.videoUrl,
          gifPath: result.gifUrl,
          status: ConvertStatus.videoCreated,
          firstFrameProcessed: result.firstFrame,
          twitterShareUrl: result.twitterShareUrl,
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
