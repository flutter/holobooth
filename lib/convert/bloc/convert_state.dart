part of 'convert_bloc.dart';

class ConvertState extends Equatable {
  const ConvertState({
    this.videoPath = '',
    this.gifPath = '',
    this.isFinished = false,
    this.status = ConvertStatus.creatingVideo,
    this.progress = 0,
    this.firstFrameProcessed,
  });

  final String videoPath;
  final String gifPath;
  final bool isFinished;
  final ConvertStatus status;
  final double progress;
  final Uint8List? firstFrameProcessed;

  ConvertState copyWith({
    String? videoPath,
    String? gifPath,
    bool? isFinished,
    ConvertStatus? status,
    double? progress,
    Uint8List? firstFrameProcessed,
  }) {
    return ConvertState(
      videoPath: videoPath ?? this.videoPath,
      gifPath: gifPath ?? this.gifPath,
      isFinished: isFinished ?? this.isFinished,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      firstFrameProcessed: firstFrameProcessed ?? this.firstFrameProcessed,
    );
  }

  @override
  List<Object?> get props => [
        videoPath,
        gifPath,
        isFinished,
        status,
        progress,
        firstFrameProcessed,
      ];
}

enum ConvertStatus {
  creatingVideo,
  videoCreated,
  error,
}
