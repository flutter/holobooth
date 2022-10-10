import 'package:flutter_test/flutter_test.dart';
import 'package:gif_compositor_platform_interface/src/method_channel_gif_compositor.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$MethodChannelGifCompositor', () {
    group('constructor', () {
      test('can be instantiated', () {
        expect(MethodChannelGifCompositor(), isA<MethodChannelGifCompositor>());
      });
    });
  });
}
