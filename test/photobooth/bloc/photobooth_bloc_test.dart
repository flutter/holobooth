// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/gen/gen.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class _MockPhotoboothCameraImage extends Mock implements PhotoboothCameraImage {
}

void main() {
  group('PhotoboothBloc', () {
    const aspectRatio = PhotoboothAspectRatio.landscape;

    late PhotoboothCameraImage image;
    late String id;

    String uuid() => id;

    setUp(() {
      id = '0';
      image = _MockPhotoboothCameraImage();
    });

    test('initial state is PhotoboothState', () {
      expect(PhotoboothBloc(uuid).state, equals(PhotoboothState()));
    });

    group('PhotoCaptured', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with image',
        build: () => PhotoboothBloc(uuid),
        act: (bloc) => bloc.add(
          PhotoCaptured(aspectRatio: aspectRatio, image: image),
        ),
        expect: () => [PhotoboothState(image: image, imageId: id)],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with image and no selected asset',
        build: () => PhotoboothBloc(uuid),
        seed: () => PhotoboothState(selectedAssetId: '0'),
        act: (bloc) => bloc.add(
          PhotoCaptured(aspectRatio: aspectRatio, image: image),
        ),
        expect: () => [PhotoboothState(image: image, imageId: id)],
      );
    });

    group('PhotoCharacterToggled', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with character '
        'when character did not exist (android)',
        build: () => PhotoboothBloc(uuid),
        act: (bloc) => bloc.add(
          PhotoCharacterToggled(character: MetaAssets.android),
        ),
        expect: () => [
          PhotoboothState(
            characters: const [PhotoAsset(id: '0', asset: MetaAssets.android)],
            selectedAssetId: '0',
          )
        ],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with character '
        'when character did not exist (dash)',
        build: () => PhotoboothBloc(uuid),
        act: (bloc) =>
            bloc.add(PhotoCharacterToggled(character: MetaAssets.dash)),
        expect: () => [
          PhotoboothState(
            characters: const [PhotoAsset(id: '0', asset: MetaAssets.dash)],
            selectedAssetId: '0',
          )
        ],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with character '
        'when character did not exist (sparky)',
        build: () => PhotoboothBloc(uuid),
        act: (bloc) => bloc.add(
          PhotoCharacterToggled(character: MetaAssets.sparky),
        ),
        expect: () => [
          PhotoboothState(
            characters: const [PhotoAsset(id: '0', asset: MetaAssets.sparky)],
            selectedAssetId: '0',
          )
        ],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with character '
        'when character did exist (android)',
        build: () => PhotoboothBloc(uuid),
        seed: () => PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: MetaAssets.android)],
        ),
        act: (bloc) => bloc.add(
          PhotoCharacterToggled(character: MetaAssets.android),
        ),
        expect: () => [PhotoboothState()],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with character '
        'when character did exist (dash)',
        build: () => PhotoboothBloc(uuid),
        seed: () => PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: MetaAssets.dash)],
        ),
        act: (bloc) => bloc.add(
          PhotoCharacterToggled(character: MetaAssets.dash),
        ),
        expect: () => [PhotoboothState()],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with character '
        'when character did exist (sparky)',
        build: () => PhotoboothBloc(uuid),
        seed: () => PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: MetaAssets.sparky)],
        ),
        act: (bloc) => bloc.add(
          PhotoCharacterToggled(character: MetaAssets.sparky),
        ),
        expect: () => [PhotoboothState()],
      );
    });

    group('PhotoCharacterDragged', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state',
        build: () => PhotoboothBloc(uuid),
        seed: () => PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: MetaAssets.sparky)],
        ),
        act: (bloc) => bloc.add(
          PhotoCharacterDragged(
            character: PhotoAsset(id: '0', asset: MetaAssets.sparky),
            update: DragUpdate(
              angle: 42,
              position: Offset(42, 42),
              constraints: Size(42, 42),
              size: Size(42, 42),
            ),
          ),
        ),
        expect: () => [
          PhotoboothState(
            characters: const [
              PhotoAsset(
                id: '0',
                asset: MetaAssets.sparky,
                angle: 42,
                position: PhotoAssetPosition(dx: 42, dy: 42),
                constraint: PhotoConstraint(width: 42, height: 42),
                size: PhotoAssetSize(width: 42, height: 42),
              ),
            ],
            selectedAssetId: '0',
          )
        ],
      );
    });

    group('PhotoStickerTapped', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with sticker',
        build: () => PhotoboothBloc(uuid),
        act: (bloc) => bloc.add(
          PhotoStickerTapped(sticker: MetaAssets.props.first),
        ),
        expect: () => [
          PhotoboothState(
            stickers: [PhotoAsset(id: '0', asset: MetaAssets.props.first)],
            selectedAssetId: '0',
          )
        ],
      );
    });

    group('PhotoStickerDragged', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state',
        build: () => PhotoboothBloc(uuid),
        seed: () => PhotoboothState(
          stickers: [PhotoAsset(id: '0', asset: MetaAssets.props.first)],
        ),
        act: (bloc) => bloc.add(
          PhotoStickerDragged(
            sticker: PhotoAsset(id: '0', asset: MetaAssets.props.first),
            update: DragUpdate(
              angle: 42,
              position: Offset(42, 42),
              constraints: Size(42, 42),
              size: Size(42, 42),
            ),
          ),
        ),
        expect: () => [
          PhotoboothState(
            stickers: [
              PhotoAsset(
                id: '0',
                asset: MetaAssets.props.first,
                angle: 42,
                position: PhotoAssetPosition(dx: 42, dy: 42),
                constraint: PhotoConstraint(width: 42, height: 42),
                size: PhotoAssetSize(width: 42, height: 42),
              ),
            ],
            selectedAssetId: '0',
          )
        ],
      );
    });

    group('PhotoClearStickersTapped', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with no stickers',
        build: () => PhotoboothBloc(uuid),
        seed: () => PhotoboothState(
          stickers: [PhotoAsset(id: '0', asset: MetaAssets.props.first)],
        ),
        act: (bloc) => bloc.add(PhotoClearStickersTapped()),
        expect: () => [PhotoboothState()],
      );
    });

    group('PhotoClearAllTapped', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with no characters or stickers',
        build: () => PhotoboothBloc(uuid),
        seed: () => PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: MetaAssets.dash)],
          stickers: [PhotoAsset(id: '0', asset: MetaAssets.props.first)],
        ),
        act: (bloc) => bloc.add(PhotoClearAllTapped()),
        expect: () => [PhotoboothState()],
      );
    });

    group('PhotoTapped', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with no selectedAssetId',
        build: () => PhotoboothBloc(uuid),
        seed: () => PhotoboothState(
          characters: const [PhotoAsset(id: '0', asset: MetaAssets.dash)],
          stickers: [PhotoAsset(id: '0', asset: MetaAssets.props.first)],
          selectedAssetId: '0',
        ),
        act: (bloc) => bloc.add(PhotoTapped()),
        expect: () => [
          PhotoboothState(
            characters: const [PhotoAsset(id: '0', asset: MetaAssets.dash)],
            stickers: [PhotoAsset(id: '0', asset: MetaAssets.props.first)],
          ),
        ],
      );
    });

    group('PhotoDeleteSelectedStickerTapped', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state without the sticker',
        build: () => PhotoboothBloc(uuid),
        seed: () => PhotoboothState(
          stickers: [PhotoAsset(id: '0', asset: MetaAssets.props.first)],
          selectedAssetId: '0',
        ),
        act: (bloc) => bloc.add(PhotoDeleteSelectedStickerTapped()),
        expect: () => [PhotoboothState()],
      );
    });
  });
}
