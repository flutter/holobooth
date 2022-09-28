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

  group('StickersLayer', () {
    setUp(() {
      photoboothBloc = _MockPhotoboothBloc();
      image = _MockPhotoboothCameraImage();
    });

    testWidgets('displays selected sticker assets', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: MetaAssets.android)],
          stickers: [PhotoAsset(id: '0', asset: MetaAssets.props.first)],
          image: image,
        ),
      );
      await tester.pumpApp(
        const StickersLayer(),
        photoboothBloc: photoboothBloc,
      );
      expect(
        find.byKey(const Key('stickersLayer_google_01_v1_0_positioned')),
        findsOneWidget,
      );
    });

    testWidgets('displays multiple selected sticker assets', (tester) async {
      when(() => photoboothBloc.state).thenReturn(
        PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: MetaAssets.android)],
          stickers: [
            PhotoAsset(id: '0', asset: MetaAssets.props.first),
            PhotoAsset(id: '1', asset: MetaAssets.props.first),
            PhotoAsset(id: '2', asset: MetaAssets.props.last),
          ],
          image: image,
        ),
      );
      await tester.pumpApp(
        const StickersLayer(),
        photoboothBloc: photoboothBloc,
      );
      expect(
        find.byKey(const Key('stickersLayer_google_01_v1_0_positioned')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('stickersLayer_google_01_v1_1_positioned')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('stickersLayer_shapes_25_v1_2_positioned')),
        findsOneWidget,
      );
    });
  });
}
