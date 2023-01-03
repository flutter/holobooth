part of 'photo_booth_bloc.dart';

class PhotoBoothState extends Equatable {
  @visibleForTesting
  const PhotoBoothState({
    this.frames = const [],
    this.isRecording = false,
    this.gettingReady = false,
    this.willExportVideo = false,
  });

  final List<RawFrame> frames;
  final bool isRecording;
  final bool gettingReady;
  final bool willExportVideo;

  bool get isFinished => !isRecording && frames.isNotEmpty;

  @override
  List<Object?> get props => [
        frames,
        isRecording,
        gettingReady,
        willExportVideo,
      ];

  PhotoBoothState copyWith({
    List<RawFrame>? frames,
    bool? isRecording,
    bool? gettingReady,
    bool? willExportVideo,
  }) {
    return PhotoBoothState(
      frames: frames ?? this.frames,
      isRecording: isRecording ?? this.isRecording,
      gettingReady: gettingReady ?? this.gettingReady,
      willExportVideo: willExportVideo ?? this.willExportVideo,
    );
  }
}
