import 'dart:typed_data';

import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:test/test.dart';

void main() {
  group('ImageData', () {
    test('can be instantiated', () {
      expect(
        ImageData(bytes: Uint8List(0), size: Size(1, 1)),
        isA<ImageData>(),
      );
    });
  });
}
