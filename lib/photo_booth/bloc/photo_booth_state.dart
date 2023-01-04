part of 'photo_booth_bloc.dart';

class PhotoBoothState extends Equatable {
  @visibleForTesting
  const PhotoBoothState({
    this.frames = const [],
    this.isRecording = false,
    this.gettingReady = false,
  });

  final List<Frame> frames;
  final bool isRecording;
  final bool gettingReady;

  bool get isFinished => !isRecording && frames.isNotEmpty;

  @override
  List<Object?> get props => [
        frames,
        isRecording,
        gettingReady,
      ];

  PhotoBoothState copyWith({
    List<Frame>? frames,
    bool? isRecording,
    bool? gettingReady,
  }) {
    return PhotoBoothState(
      frames: frames ?? this.frames,
      isRecording: isRecording ?? this.isRecording,
      gettingReady: gettingReady ?? this.gettingReady,
    );
  }
}
