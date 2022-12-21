part of 'photo_booth_bloc.dart';

abstract class PhotoBoothEvent extends Equatable {
  const PhotoBoothEvent();
  @override
  List<Object> get props => [];
}

class PhotoBoothRecordingStarted extends PhotoBoothEvent {
  const PhotoBoothRecordingStarted();
}

class PhotoBoothRecordingFinished extends PhotoBoothEvent {
  const PhotoBoothRecordingFinished(this.frames);

  final List<RawFrame> frames;

  @override
  List<Object> get props => [frames];
}
