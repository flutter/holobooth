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
  List<Object?> get props => [frames];

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

// TODO(oscar): To be deleted after one single photobooth exists in the project
class PhotoConstraint extends Equatable {
  const PhotoConstraint({this.width = 1, this.height = 1});

  final double width;
  final double height;

  @override
  List<Object> get props => [width, height];
}
