// ignore_for_file: prefer_const_constructors
import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

class _MockPhotoBoothBloc extends MockBloc<PhotoBoothEvent, PhotoBoothState>
    implements PhotoBoothBloc {}

class FakePhotoboothCameraImage extends Fake implements PhotoboothCameraImage {
  @override
  PhotoConstraint get constraint => PhotoConstraint();
  @override
  final String data = '';
}

void main() {
  final image = FakePhotoboothCameraImage();

  late PhotoBoothBloc photoboothBloc;

  setUpAll(() {});

  setUp(() {
    photoboothBloc = _MockPhotoBoothBloc();
    when(() => photoboothBloc.state)
        .thenReturn(PhotoBoothState(images: UnmodifiableListView([image])));
  });

  group('AnimatedPhotoboothPhoto', () {
    testWidgets(
        'displays AnimatedPhotoboothPhotoLandscape '
        'on screen size small', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 800));

      await tester.pumpSubject(
        AnimatedPhotoboothPhoto(image: image),
        photoboothBloc,
      );
      expect(
        find.byType(AnimatedPhotoboothPhotoLandscape),
        findsOneWidget,
      );
    });

    testWidgets(
        'displays AnimatedPhotoboothPhotoLandscape '
        'on screen size medium', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.medium, 800));

      await tester.pumpSubject(
        AnimatedPhotoboothPhoto(image: image),
        photoboothBloc,
      );
      expect(
        find.byType(AnimatedPhotoboothPhotoLandscape),
        findsOneWidget,
      );
    });

    testWidgets(
        'displays AnimatedPhotoboothPhotoLandscape '
        'on screen size large', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 800));

      await tester.pumpSubject(
        AnimatedPhotoboothPhoto(image: image),
        photoboothBloc,
      );
      expect(
        find.byType(AnimatedPhotoboothPhotoLandscape),
        findsOneWidget,
      );
    });

    testWidgets(
        'displays AnimatedPhotoboothPhotoLandscape '
        'on screen size xLarge', (tester) async {
      tester.setDisplaySize(
        const Size(
          PhotoboothBreakpoints.large + 100,
          800,
        ),
      );
      await tester.pumpSubject(
        AnimatedPhotoboothPhoto(image: image),
        photoboothBloc,
      );

      expect(
        find.byType(AnimatedPhotoboothPhotoLandscape),
        findsOneWidget,
      );
    });

    testWidgets(
        'displays AnimatedPhotoboothPhotoLandscape '
        'when aspect ratio is landscape '
        'with isPhotoVisible false', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 800));

      await tester.pumpSubject(
        AnimatedPhotoboothPhoto(image: image),
        photoboothBloc,
      );
      final widget = tester.widget<AnimatedPhotoboothPhotoLandscape>(
        find.byType(AnimatedPhotoboothPhotoLandscape),
      );
      expect(widget.isPhotoVisible, false);
    });

    testWidgets(
        'displays AnimatedPhotoboothPhotoLandscape '
        'when aspect ratio is landscape '
        'with isPhotoVisible true '
        'after 2 seconds', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 800));

      await tester.pumpSubject(
        AnimatedPhotoboothPhoto(image: image),
        photoboothBloc,
      );
      await tester.pump(Duration(seconds: 2));
      final widget = tester.widget<AnimatedPhotoboothPhotoLandscape>(
        find.byType(AnimatedPhotoboothPhotoLandscape),
      );
      expect(widget.isPhotoVisible, true);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    AnimatedPhotoboothPhoto subject,
    PhotoBoothBloc drawerSelectionBloc,
  ) =>
      pumpApp(
        MultiBlocProvider(
          providers: [BlocProvider.value(value: drawerSelectionBloc)],
          child: subject,
        ),
      );
}
