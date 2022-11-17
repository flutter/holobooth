import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';

void main() {
  group('assets', () {
    group('returns image for', () {
      test('blueCircle', () {
        expect(() => Assets.backgrounds.blueCircle.image(), returnsNormally);
      });

      test('photoboothBackground', () {
        expect(
          () => Assets.backgrounds.photoboothBackground.image(),
          returnsNormally,
        );
      });

      test('redBox', () {
        expect(() => Assets.backgrounds.redBox.image(), returnsNormally);
      });

      test('yellowPlus', () {
        expect(() => Assets.backgrounds.yellowPlus.image(), returnsNormally);
      });
    });

    group('returns correct path for', () {
      test('Asset', () {
        expect(Assets.characters.dash.path, 'assets/characters/dash.png');
      });

      test('Rive', () {
        expect(Assets.animations.dash.path, 'assets/animations/dash.riv');
      });
    });
  });
}
