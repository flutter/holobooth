part of 'convert_bloc.dart';

class ConvertState extends Equatable {
  const ConvertState({
    this.videoPath = '',
    this.gifPath = '',
    this.status = ConvertStatus.loadingFrames,
    this.firstFrameProcessed,
    this.twitterShareUrl = '',
    this.facebookShareUrl = '',
    this.triesCount = 0,
    this.shareStatus = ShareStatus.initial,
    this.shareType = ShareType.none,
  });

  final String videoPath;
  final String gifPath;
  final ConvertStatus status;
  final Uint8List? firstFrameProcessed;
  final String twitterShareUrl;
  final String facebookShareUrl;
  final int triesCount;
  final ShareStatus shareStatus;
  final ShareType shareType;

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
    ShareType? shareType,
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
      shareType: shareType ?? this.shareType,
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
        shareType,
      ];
}

enum ConvertStatus {
  loadingFrames,
  loadedFrames,
  errorLoadingFrames,
  creatingVideo,
  videoCreated,
  errorGeneratingVideo,
}

enum ShareStatus {
  initial,
  waiting,
  ready,
}

enum ShareType {
  none,
  socialMedia,
  download,
}
