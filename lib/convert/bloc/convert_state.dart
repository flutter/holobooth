part of 'convert_bloc.dart';

class ConvertState extends Equatable {
  const ConvertState({
    this.videoPath = '',
    this.gifPath = '',
    this.status = ConvertStatus.creatingVideo,
    this.firstFrameProcessed,
    this.twitterShareUrl = '',
    this.facebookShareUrl = '',
    this.frames = const [],
    this.triesCount = 0,
    this.framesProcessed = const [],
    this.shareStatus = ShareStatus.initial,
  });

  final String videoPath;
  final String gifPath;
  final ConvertStatus status;
  final Uint8List? firstFrameProcessed;
  final String twitterShareUrl;
  final String facebookShareUrl;
  final List<Image> frames;
  final int triesCount;
  final List<Uint8List> framesProcessed;
  final ShareStatus shareStatus;

  bool get maxTriesReached => triesCount == 3;

  ConvertState copyWith({
    String? videoPath,
    String? gifPath,
    ConvertStatus? status,
    Uint8List? firstFrameProcessed,
    String? twitterShareUrl,
    String? facebookShareUrl,
    List<Image>? frames,
    int? triesCount,
    List<Uint8List>? framesProcessed,
    ShareStatus? shareStatus,
  }) {
    return ConvertState(
      videoPath: videoPath ?? this.videoPath,
      gifPath: gifPath ?? this.gifPath,
      status: status ?? this.status,
      firstFrameProcessed: firstFrameProcessed ?? this.firstFrameProcessed,
      twitterShareUrl: twitterShareUrl ?? this.twitterShareUrl,
      facebookShareUrl: facebookShareUrl ?? this.facebookShareUrl,
      frames: frames ?? this.frames,
      triesCount: triesCount ?? this.triesCount,
      framesProcessed: framesProcessed ?? this.framesProcessed,
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
        frames,
        triesCount,
        framesProcessed,
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
