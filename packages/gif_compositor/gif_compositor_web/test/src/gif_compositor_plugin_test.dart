/// **NOTE**: This test file should be runned on web, to do so use:
/// ``` flutter test --platform chrome ```
@TestOn('chrome')

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

    group('composite', () {
      test(
        'throws an AssertionError when fileName does not end in ".gif"',
        () {
          expect(
            () => GifCompositorWeb().composite(
              images: [],
              fileName: 'test',
            ),
            throwsAssertionError,
          );
        },
      );

      test(
        'returns normally',
        () {
          // TODO(alestiago): Investigate on how to mock the singleton
          // `JsIsolatedWorkerImpl`.
        },
      );
    });
  });
}
