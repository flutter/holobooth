part of 'download_bloc.dart';

enum DownloadStatus {
  idle,
  fetching,
  completed,
}

class DownloadState extends Equatable {
  const DownloadState({
    required this.videoPath,
    required this.status,
  });

  const DownloadState.initial({
    required String videoPath,
  }) : this(
          videoPath: videoPath,
          status: DownloadStatus.idle,
        );

  final String videoPath;

  final DownloadStatus status;

  DownloadState copyWith({
    String? videoPath,
    DownloadStatus? status,
  }) {
    return DownloadState(
      videoPath: videoPath ?? this.videoPath,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [videoPath, status];
}
