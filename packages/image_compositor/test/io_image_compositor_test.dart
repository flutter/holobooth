@TestOn('!chrome')

import 'package:image_compositor/image_compositor.dart';
import 'package:test/test.dart';

void main() {
  group('ImageCompositor', () {
    test('is unsupported in other platforms', () {
      final compositor = ImageCompositor();
      expect(
        () => compositor.composite(
          data: '',
          width: 1,
          height: 1,
          layers: <dynamic>[],
          aspectRatio: 1,
        ),
        throwsUnsupportedError,
      );
    });
  });
}
