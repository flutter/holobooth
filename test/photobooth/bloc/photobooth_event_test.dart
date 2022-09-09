import 'package:camera/camera.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:test/test.dart';

class _MockCameraImage extends Mock implements CameraImage {}

class _MockAsset extends Mock implements Asset {}

class _MockPhotoAsset extends Mock implements PhotoAsset {}

class _MockDragUpdate extends Mock implements DragUpdate {}

void main() {
  group('PhotoboothEvent', () {
    group('PhotoCaptured', () {
      test('support value equality', () {
        const aspectRatio = PhotoboothAspectRatio.portrait;
        final image = _MockCameraImage();
        final instanceA = PhotoCaptured(aspectRatio: aspectRatio, image: image);
        final instanceB = PhotoCaptured(aspectRatio: aspectRatio, image: image);
        expect(instanceA, equals(instanceB));
      });
    });

    group('PhotoCharacterToggled', () {
      test('support value equality', () {
        final character = _MockAsset();
        final instanceA = PhotoCharacterToggled(character: character);
        final instanceB = PhotoCharacterToggled(character: character);
        expect(instanceA, equals(instanceB));
      });
    });

    group('PhotoCharacterDragged', () {
      test('support value equality', () {
        final character = _MockPhotoAsset();
        final update = _MockDragUpdate();
        final instanceA = PhotoCharacterDragged(
          character: character,
          update: update,
        );
        final instanceB = PhotoCharacterDragged(
          character: character,
          update: update,
        );
        expect(instanceA, equals(instanceB));
      });
    });

    group('PhotoStickerTapped', () {
      test('support value equality', () {
        final sticker = _MockAsset();
        final instanceA = PhotoStickerTapped(sticker: sticker);
        final instanceB = PhotoStickerTapped(sticker: sticker);
        expect(instanceA, equals(instanceB));
      });
    });

    group('PhotoStickerDragged', () {
      test('support value equality', () {
        final sticker = _MockPhotoAsset();
        final update = _MockDragUpdate();
        final instanceA = PhotoStickerDragged(
          sticker: sticker,
          update: update,
        );
        final instanceB = PhotoStickerDragged(
          sticker: sticker,
          update: update,
        );
        expect(instanceA, equals(instanceB));
      });
    });
  });
}
