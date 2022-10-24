import 'package:gif_compositor_platform_interface/src/method_channel_gif_compositor.dart';
import 'package:test/test.dart';

void main() {
  group('$MethodChannelGifCompositor', () {
    group('constructor', () {
      test('can be instantiated', () {
        expect(MethodChannelGifCompositor(), isA<MethodChannelGifCompositor>());
      });
    });
  });
}
