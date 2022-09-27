part of 'multiple_capture_bloc.dart';

const maxPhotos = 5;

class MultipleCaptureState extends Equatable {
  const MultipleCaptureState({
    this.images = const [],
  });

  final List<PhotoboothCameraImage> images;

  bool get isFinished => images.length == maxPhotos;

  @override
  List<Object> get props => [images];

  MultipleCaptureState copyWith({
    List<PhotoboothCameraImage>? images,
  }) {
    return MultipleCaptureState(
      images: images ?? this.images,
    );
  }
}

// TODO(oscar): To be deleted after one single photobooth exists in the project
class PhotoboothCameraImage extends Equatable {
  const PhotoboothCameraImage({
    required this.constraint,
    required this.data,
  });

  final PhotoConstraint constraint;
  final String data;

  @override
  List<Object> get props => [
        constraint,
        data,
      ];
}

// TODO(oscar): To be deleted after one single photobooth exists in the project
class PhotoConstraint extends Equatable {
  const PhotoConstraint({this.width = 1, this.height = 1});

  final double width;
  final double height;

  @override
  List<Object> get props => [width, height];
}
