// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/helpers.dart';

class _MockPhotoboothBloc extends MockBloc<PhotoboothEvent, PhotoboothState>
    implements PhotoboothBloc {}

class _MockPhotoboothCameraImage extends Mock implements PhotoboothCameraImage {
}

void main() {
  late PhotoboothCameraImage image;
  late PhotoboothBloc photoboothBloc;

  group('CharactersLayer', () {
    setUp(() {
      image = _MockPhotoboothCameraImage();
      photoboothBloc = _MockPhotoboothBloc();
    });

    testWidgets('renders Android character assert', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: MetaAssets.android)],
          image: image,
        ),
      );
      await tester.pumpApp(
        CharactersLayer(),
        photoboothBloc: photoboothBloc,
      );
      expect(
        find.byKey(const Key('charactersLayer_android_positioned')),
        findsOneWidget,
      );
    });

    testWidgets('renders Dash character assert', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: MetaAssets.dash)],
          image: image,
        ),
      );
      await tester.pumpApp(
        CharactersLayer(),
        photoboothBloc: photoboothBloc,
      );
      expect(
        find.byKey(const Key('charactersLayer_dash_positioned')),
        findsOneWidget,
      );
    });

    testWidgets('renders Sparky character assert', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: MetaAssets.sparky)],
          image: image,
        ),
      );
      await tester.pumpApp(
        CharactersLayer(),
        photoboothBloc: photoboothBloc,
      );
      expect(
        find.byKey(const Key('charactersLayer_sparky_positioned')),
        findsOneWidget,
      );
    });
  });
}
