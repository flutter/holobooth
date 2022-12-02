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

class PhotoBoothCountdownStarted extends PhotoBoothEvent {
  const PhotoBoothCountdownStarted();

  @override
  List<Object> get props => [];
}

class PhotoBoothCountdownFinished extends PhotoBoothEvent {
  const PhotoBoothCountdownFinished();

  @override
  List<Object> get props => [];
}
