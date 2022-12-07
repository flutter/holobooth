part of 'photo_booth_bloc.dart';

class PhotoBoothState extends Equatable {
  @visibleForTesting
  const PhotoBoothState({
    required this.images,
    this.frames,
  }) : assert(
          images.length <= totalNumberOfPhotos,
          'The total number of photos should be less than $totalNumberOfPhotos',
        );

  PhotoBoothState.empty() : this(images: UnmodifiableListView([]));

  /// The amount of pictures the photobooth will take.
  static const totalNumberOfPhotos = 1;

  /// The images that have been taken by the Photbooth.
  ///
  /// The length is not expected to be greater than [totalNumberOfPhotos].
  final UnmodifiableListView<PhotoboothCameraImage> images;

  final UnmodifiableListView<RawFrame>? frames;

  /// Whether all of the pictures has been taken.
  bool get isFinished => images.isNotEmpty && frames != null;

  @override
  List<Object?> get props => [images, frames];

  PhotoBoothState copyWith({
    UnmodifiableListView<PhotoboothCameraImage>? images,
    UnmodifiableListView<RawFrame>? frames,
  }) {
    return PhotoBoothState(
      images: images ?? this.images,
      frames: frames ?? this.frames,
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
