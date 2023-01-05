part of 'convert_bloc.dart';

class ConvertState extends Equatable {
  const ConvertState({
    this.videoPath = '',
    this.gifPath = '',
    this.isFinished = false,
    this.status = ConvertStatus.loadingFrames,
    this.progress = 0,
    this.processedFrames = const [],
  });

  final String videoPath;
  final String gifPath;
  final bool isFinished;
  final ConvertStatus status;
  final double progress;
  final List<Uint8List> processedFrames;

  ConvertState copyWith({
    String? videoPath,
    String? gifPath,
    bool? isFinished,
    ConvertStatus? status,
    double? progress,
    List<Uint8List>? processedFrames,
  }) {
    return ConvertState(
      videoPath: videoPath ?? this.videoPath,
      gifPath: gifPath ?? this.gifPath,
      isFinished: isFinished ?? this.isFinished,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      processedFrames: processedFrames ?? this.processedFrames,
    );
  }

  @override
  List<Object?> get props => [
        videoPath,
        gifPath,
        isFinished,
        status,
        progress,
        processedFrames,
      ];
}

enum ConvertStatus {
  loadingFrames,
  framesProcessed,
  creatingVideo,
  videoCreated,
  error,
}
