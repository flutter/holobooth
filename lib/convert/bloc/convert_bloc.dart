import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:download_repository/download_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:screen_recorder/screen_recorder.dart';

part 'convert_event.dart';
part 'convert_state.dart';

class ConvertBloc extends Bloc<ConvertEvent, ConvertState> {
  ConvertBloc({
    required ConvertRepository convertRepository,
    required DownloadRepository downloadRepository,
  })  : _convertRepository = convertRepository,
        _downloadRepository = downloadRepository,
        super(const ConvertState()) {
    on<GenerateVideoRequested>(_generateVideo);
  }

  final ConvertRepository _convertRepository;
  final DownloadRepository _downloadRepository;

  FutureOr<void> _generateVideo(
    GenerateVideoRequested event,
    Emitter<ConvertState> emit,
  ) async {
    emit(state.copyWith(status: ConvertStatus.creatingVideo));
    try {
      final result = await _convertRepository
          .generateVideo(event.frames.map((e) => e.image).toList());
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

  void download(String extension) {
    final videoHash = state.videoPath.split('/').last.split('.').first;

    final fileName = '$videoHash.$extension';
    final mimeType = extension == 'mp4' ? 'video/mp4' : 'image/gif';
    unawaited(
      _downloadRepository.downloadFile(
        fileName,
        mimeType,
      ),
    );
  }
}
