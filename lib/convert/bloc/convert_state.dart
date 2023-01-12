part of 'convert_bloc.dart';

class ConvertState extends Equatable {
  const ConvertState({
    this.videoPath = '',
    this.gifPath = '',
    this.status = ConvertStatus.creatingVideo,
    this.firstFrameProcessed,
    this.twitterShareUrl = '',
  });

  final String videoPath;
  final String gifPath;
  final ConvertStatus status;
  final Uint8List? firstFrameProcessed;
  final String twitterShareUrl;

  ConvertState copyWith({
    String? videoPath,
    String? gifPath,
    ConvertStatus? status,
    Uint8List? firstFrameProcessed,
    String? twitterShareUrl,
  }) {
    return ConvertState(
      videoPath: videoPath ?? this.videoPath,
      gifPath: gifPath ?? this.gifPath,
      status: status ?? this.status,
      firstFrameProcessed: firstFrameProcessed ?? this.firstFrameProcessed,
      twitterShareUrl: twitterShareUrl ?? this.twitterShareUrl,
    );
  }

  @override
  List<Object?> get props => [
        videoPath,
        gifPath,
        status,
        firstFrameProcessed,
        twitterShareUrl,
      ];
}

enum ConvertStatus {
  creatingVideo,
  videoCreated,
  error,
}
