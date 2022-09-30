part of 'multiple_capture_bloc.dart';

abstract class MultipleCaptureEvent extends Equatable {
  const MultipleCaptureEvent();
}

class MultipleCaptureOnPhotoTaken extends MultipleCaptureEvent {
  const MultipleCaptureOnPhotoTaken({required this.image});

  final PhotoboothCameraImage image;

  @override
  List<Object> get props => [image];
}
