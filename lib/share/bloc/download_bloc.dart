import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:download_repository/download_repository.dart';
import 'package:equatable/equatable.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  DownloadBloc({
    required DownloadRepository downloadRepository,
  })  : _downloadRepository = downloadRepository,
        super(const DownloadState()) {
    on<DownloadRequested>(_onDownloadEvent);
  }

  final DownloadRepository _downloadRepository;

  Future<void> _onDownloadEvent(
    DownloadRequested event,
    Emitter<DownloadState> emit,
  ) async {
    emit(state.copyWith(status: DownloadStatus.fetching));
    final videoHash = event.path.split('/').last.split('.').first;
    final fileName = '$videoHash.${event.extension}';
    final mimeType = event.extension == 'mp4' ? 'video/mp4' : 'image/gif';
    await _downloadRepository.downloadFile(
      fileName,
      mimeType,
    );
    emit(state.copyWith(status: DownloadStatus.completed));
  }
}
