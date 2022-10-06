import 'package:flutter_test/flutter_test.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

void main() {
  group('Image Data', () {
    test('can be instaniated', () {
      expect(ImageData, isNotNull);
    });
  });
}
