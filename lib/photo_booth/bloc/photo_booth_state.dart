part of 'photo_booth_bloc.dart';

class PhotoBoothState extends Equatable {
  @visibleForTesting
  const PhotoBoothState({
    this.frames = const [],
    this.isRecording = false,
  });

  final List<RawFrame> frames;
  final bool isRecording;

  bool get isFinished => !isRecording && frames.isNotEmpty;

  @override
  List<Object?> get props => [frames, isRecording];

  PhotoBoothState copyWith({
    List<RawFrame>? frames,
    bool? isRecording,
  }) {
    return PhotoBoothState(
      frames: frames ?? this.frames,
      isRecording: isRecording ?? this.isRecording,
    );
  }
}
