import 'package:flutter_test/flutter_test.dart';
import 'package:gif_compositor_platform_interface/gif_compositor_platform_interface.dart';
import 'package:gif_compositor_web/src/gif_compositor_plugin.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$GifCompositorWeb', () {
    test('can be registered', () {
      GifCompositorWeb.registerWith();
      expect(GifCompositorPlatform.instance, isA<GifCompositorWeb>());
    });
  });
}
