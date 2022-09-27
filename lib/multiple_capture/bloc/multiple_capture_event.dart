part of 'multiple_capture_bloc.dart';

abstract class MultipleCaptureEvent extends Equatable {
  const MultipleCaptureEvent();
}

class MultipleCapturePhotoTaken extends MultipleCaptureEvent {
  const MultipleCapturePhotoTaken({required this.image});

  final PhotoboothCameraImage image;

  @override
  List<Object> get props => [image];
}
