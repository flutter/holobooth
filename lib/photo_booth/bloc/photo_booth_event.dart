part of 'photo_booth_bloc.dart';

abstract class PhotoBoothEvent extends Equatable {
  const PhotoBoothEvent();
}

class PhotoBoothOnPhotoTaken extends PhotoBoothEvent {
  const PhotoBoothOnPhotoTaken({required this.image});

  final PhotoboothCameraImage image;

  @override
  List<Object> get props => [image];
}

class PhotoBoothRecordingStarted extends PhotoBoothEvent {
  const PhotoBoothRecordingStarted();

  @override
  List<Object> get props => [];
}

class PhotoBoothRecordingFinished extends PhotoBoothEvent {
  const PhotoBoothRecordingFinished();

  @override
  List<Object> get props => [];
}
