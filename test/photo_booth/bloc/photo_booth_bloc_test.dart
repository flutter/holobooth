import 'package:bloc_test/bloc_test.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:screen_recorder/screen_recorder.dart';

class _MockRawFrame extends Mock implements RawFrame {}

void main() {
  group('PhotoBoothBloc', () {
    group('PhotoBoothRecordingStarted', () {
      blocTest<PhotoBoothBloc, PhotoBoothState>(
        'emits recording.',
        build: PhotoBoothBloc.new,
        act: (bloc) => bloc.add(PhotoBoothRecordingStarted()),
        expect: () => <PhotoBoothState>[
          PhotoBoothState(isRecording: true),
        ],
      );
    });

    group('PhotoBoothPreparingStarted', () {
      blocTest<PhotoBoothBloc, PhotoBoothState>(
        'emits state with preparing == true.',
        build: PhotoBoothBloc.new,
        seed: () => PhotoBoothState(isRecording: true),
        act: (bloc) => bloc.add(PhotoBoothPreparingStarted()),
        expect: () => <PhotoBoothState>[
          PhotoBoothState(isPreparing: true),
        ],
      );
    });

    group('PhotoBoothRecordingFinished', () {
      final frames = UnmodifiableListView([_MockRawFrame()]);

      blocTest<PhotoBoothBloc, PhotoBoothState>(
        'emits state with frames recorded.',
        build: PhotoBoothBloc.new,
        seed: () => PhotoBoothState(isRecording: true),
        act: (bloc) => bloc.add(PhotoBoothRecordingFinished(frames)),
        expect: () => <PhotoBoothState>[
          PhotoBoothState(frames: frames),
        ],
      );
    });
  });
}
