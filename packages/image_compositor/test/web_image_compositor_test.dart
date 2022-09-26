@TestOn('chrome')

import 'package:flutter_test/flutter_test.dart';
import 'package:image_compositor/src/web.dart';

void main() {
  group('ImageCompositor', () {
    test('can be instantiated', () {
      expect(ImageCompositor(), isNotNull);
    });
  });
}
