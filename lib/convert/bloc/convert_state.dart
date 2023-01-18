part of 'convert_bloc.dart';

class ConvertState extends Equatable {
  const ConvertState({
    this.videoPath = '',
    this.gifPath = '',
    this.status = ConvertStatus.creatingVideo,
    this.firstFrameProcessed,
    this.twitterShareUrl = '',
    this.facebookShareUrl = '',
    this.triesCount = 0,
    this.shareStatus = ShareStatus.initial,
  });

  final String videoPath;
  final String gifPath;
  final ConvertStatus status;
  final Uint8List? firstFrameProcessed;
  final String twitterShareUrl;
  final String facebookShareUrl;
  final int triesCount;
  final ShareStatus shareStatus;

  bool get maxTriesReached => triesCount == 3;

  ConvertState copyWith({
    String? videoPath,
    String? gifPath,
    ConvertStatus? status,
    Uint8List? firstFrameProcessed,
    String? twitterShareUrl,
    String? facebookShareUrl,
    int? triesCount,
    ShareStatus? shareStatus,
  }) {
    return ConvertState(
      videoPath: videoPath ?? this.videoPath,
      gifPath: gifPath ?? this.gifPath,
      status: status ?? this.status,
      firstFrameProcessed: firstFrameProcessed ?? this.firstFrameProcessed,
      twitterShareUrl: twitterShareUrl ?? this.twitterShareUrl,
      facebookShareUrl: facebookShareUrl ?? this.facebookShareUrl,
      triesCount: triesCount ?? this.triesCount,
      shareStatus: shareStatus ?? this.shareStatus,
    );
  }

  @override
  List<Object?> get props => [
        videoPath,
        gifPath,
        status,
        firstFrameProcessed,
        twitterShareUrl,
        facebookShareUrl,
        triesCount,
        shareStatus,
      ];
}

enum ConvertStatus {
  loadingFrames,
  loadedFrames,
  creatingVideo,
  videoCreated,
  error,
}

enum ShareStatus {
  initial,
  waiting,
  success,
}
