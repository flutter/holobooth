// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:gif_compositor_platform_interface/gif_compositor_platform_interface.dart';

void main() {
  group('$GifCompositorException', () {
    group('constructor', () {
      test('can be instantiated', () {
        expect(
          GifCompositorException(''),
          isA<GifCompositorException>(),
        );
      });
    });

    group('toString', () {
      const testMessage = 'message';

      test('returns normally', () {
        expect(
          () => GifCompositorException(testMessage).toString(),
          returnsNormally,
        );
      });

      test('returns correct value', () {
        expect(
          GifCompositorException(testMessage).toString(),
          '$GifCompositorException: $testMessage',
        );
      });
    });
  });
}
