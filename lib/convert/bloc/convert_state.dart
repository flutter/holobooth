part of 'convert_bloc.dart';

class ConvertState extends Equatable {
  const ConvertState({
    this.videoPath = '',
    this.gifPath = '',
    this.status = ConvertStatus.creatingVideo,
    this.firstFrameProcessed,
  });

  final String videoPath;
  final String gifPath;
  final ConvertStatus status;
  final Uint8List? firstFrameProcessed;

  ConvertState copyWith({
    String? videoPath,
    String? gifPath,
    ConvertStatus? status,
    Uint8List? firstFrameProcessed,
  }) {
    return ConvertState(
      videoPath: videoPath ?? this.videoPath,
      gifPath: gifPath ?? this.gifPath,
      status: status ?? this.status,
      firstFrameProcessed: firstFrameProcessed ?? this.firstFrameProcessed,
    );
  }

  @override
  List<Object?> get props => [
        videoPath,
        gifPath,
        status,
        firstFrameProcessed,
      ];
}

enum ConvertStatus {
  creatingVideo,
  videoCreated,
  error,
}
