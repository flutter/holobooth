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
  });

  final String videoPath;
  final String gifPath;
  final ConvertStatus status;
  final Uint8List? firstFrameProcessed;
  final String twitterShareUrl;
  final String facebookShareUrl;
  final List<Image> frames;

  ConvertState copyWith({
    String? videoPath,
    String? gifPath,
    ConvertStatus? status,
    Uint8List? firstFrameProcessed,
    String? twitterShareUrl,
    String? facebookShareUrl,
    List<Image>? frames,
  }) {
    return ConvertState(
      videoPath: videoPath ?? this.videoPath,
      gifPath: gifPath ?? this.gifPath,
      status: status ?? this.status,
      firstFrameProcessed: firstFrameProcessed ?? this.firstFrameProcessed,
      twitterShareUrl: twitterShareUrl ?? this.twitterShareUrl,
      facebookShareUrl: facebookShareUrl ?? this.facebookShareUrl,
      frames: frames ?? this.frames,
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
      ];
}

enum ConvertStatus {
  creatingVideo,
  videoCreated,
  error,
}
