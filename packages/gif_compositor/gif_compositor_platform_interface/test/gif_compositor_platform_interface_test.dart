import 'dart:typed_data';

import 'package:gif_compositor_platform_interface/gif_compositor_platform_interface.dart';
import 'package:test/test.dart';

class _GifCompositorMock extends GifCompositorPlatform {}

void main() {
  group('$GifCompositorPlatform', () {
    late GifCompositorPlatform gifCompositorPlatform;

    setUp(() {
      gifCompositorPlatform = _GifCompositorMock();
      GifCompositorPlatform.instance = gifCompositorPlatform;
    });

    group('composite', () {
      test('throws an UnimplementedError', () async {
        await expectLater(
          () async => GifCompositorPlatform.instance.composite(
            images: <Uint8List>[],
            fileName: '',
          ),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });
  });
}
