// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

class MockImageData extends Mock implements ImageData {}

void main() {
  late ImageData _imageData;

  setUp(() {
    _imageData = MockImageData();
  });
  group('Image Data', () {
    test('can be instaniated', () {
      expect(_imageData, isNotNull);
    });
  });
}
