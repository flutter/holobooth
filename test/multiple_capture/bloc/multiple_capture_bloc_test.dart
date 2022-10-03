import 'package:bloc_test/bloc_test.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';
import 'package:mocktail/mocktail.dart';

class _MockPhotoboothCameraImage extends Mock implements PhotoboothCameraImage {
}

void main() {
  group('MultipleCaptureBloc', () {
    group('MultipleCaptureOnPhotoTaken', () {
      late PhotoboothCameraImage image;

      setUp(() {
        image = _MockPhotoboothCameraImage();
      });

      blocTest<MultipleCaptureBloc, MultipleCaptureState>(
        'emits MultipleCaptureState with adding image to images',
        build: MultipleCaptureBloc.new,
        act: (bloc) => bloc.add(MultipleCaptureOnPhotoTaken(image: image)),
        expect: () => <MultipleCaptureState>[
          MultipleCaptureState(images: UnmodifiableListView([image])),
        ],
      );
    });
  });
}
