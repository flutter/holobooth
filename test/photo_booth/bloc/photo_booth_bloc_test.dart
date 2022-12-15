import 'package:bloc_test/bloc_test.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:screen_recorder/screen_recorder.dart';

class _MockPhotoboothCameraImage extends Mock
    implements PhotoboothCameraImage {}

class _MockRawFrame extends Mock implements RawFrame {}

void main() {
  group('PhotoBoothBloc', () {
    group('PhotoBoothOnPhotoTaken', () {
      late PhotoboothCameraImage image;

      setUp(() {
        image = _MockPhotoboothCameraImage();
      });

      blocTest<PhotoBoothBloc, PhotoBoothState>(
        'emits MultipleCaptureState with adding image to images',
        build: PhotoBoothBloc.new,
        act: (bloc) => bloc.add(PhotoBoothOnPhotoTaken(image: image)),
        expect: () => <PhotoBoothState>[
          PhotoBoothState(images: UnmodifiableListView([image])),
        ],
      );
    });

    group('PhotoBoothRecordingStarted', () {
      blocTest<PhotoBoothBloc, PhotoBoothState>(
        'emits recording.',
        build: PhotoBoothBloc.new,
        act: (bloc) => bloc.add(PhotoBoothRecordingStarted()),
        expect: () => <PhotoBoothState>[
          PhotoBoothState.empty().copyWith(isRecording: true),
        ],
      );
    });

    group('PhotoBoothRecordingFinished', () {
      final frames = UnmodifiableListView([_MockRawFrame()]);

      blocTest<PhotoBoothBloc, PhotoBoothState>(
        'emits nothing.',
        build: PhotoBoothBloc.new,
        act: (bloc) => bloc.add(PhotoBoothRecordingFinished(frames)),
        expect: () => <PhotoBoothState>[
          PhotoBoothState.empty().copyWith(frames: frames),
        ],
      );
    });
  });
}
