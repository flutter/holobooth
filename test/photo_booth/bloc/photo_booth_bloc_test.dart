import 'dart:ui' as ui;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:screen_recorder/screen_recorder.dart';

class _MockImage extends Mock implements ui.Image {}

void main() {
  group('PhotoBoothBloc', () {
    late List<Frame> frames;
    setUp(() {
      frames = List.filled(10, Frame(Duration.zero, _MockImage()));
    });

    group('PhotoBoothGetReadyStarted', () {
      blocTest<PhotoBoothBloc, PhotoBoothState>(
        'emits state with preparing == true.',
        build: PhotoBoothBloc.new,
        act: (bloc) => bloc.add(PhotoBoothGetReadyStarted()),
        expect: () => <PhotoBoothState>[
          PhotoBoothState(gettingReady: true),
        ],
      );
    });

    group('PhotoBoothRecordingStarted', () {
      blocTest<PhotoBoothBloc, PhotoBoothState>(
        'emits recording.',
        build: PhotoBoothBloc.new,
        seed: () => PhotoBoothState(gettingReady: true),
        act: (bloc) => bloc.add(PhotoBoothRecordingStarted()),
        expect: () => <PhotoBoothState>[
          PhotoBoothState(isRecording: true),
        ],
      );
    });

    group('PhotoBoothRecordingFinished', () {
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
