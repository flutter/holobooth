part of 'photo_booth_bloc.dart';

class PhotoBoothState extends Equatable {
  @visibleForTesting
  const PhotoBoothState({
    this.frames = const [],
    this.isRecording = false,
    this.isPreparing = false,
  });

  final List<RawFrame> frames;
  final bool isRecording;
  final bool isPreparing;

  bool get isFinished => !isRecording && frames.isNotEmpty;

  @override
  List<Object?> get props => [
        frames,
        isRecording,
        isPreparing,
      ];

  PhotoBoothState copyWith({
    List<RawFrame>? frames,
    bool? isRecording,
    bool? isPreparing,
  }) {
    return PhotoBoothState(
      frames: frames ?? this.frames,
      isRecording: isRecording ?? this.isRecording,
      isPreparing: isPreparing ?? this.isPreparing,
    );
  }
}
