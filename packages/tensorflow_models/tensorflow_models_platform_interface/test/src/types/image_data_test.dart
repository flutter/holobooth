import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

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
