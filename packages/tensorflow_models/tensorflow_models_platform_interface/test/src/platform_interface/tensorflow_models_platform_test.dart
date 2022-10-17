import 'package:flutter_test/flutter_test.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

class _TestTensorflowModelsPlatform extends TensorflowModelsPlatform {}

void main() {
  group('TensorflowModelsPlatform', () {
    group('instance', () {
      test('sets the instance', () {
        final newPlatform = _TestTensorflowModelsPlatform();
        expect(
          TensorflowModelsPlatform.instance,
          isNot(equals(newPlatform)),
        );
        TensorflowModelsPlatform.instance = newPlatform;
        expect(TensorflowModelsPlatform.instance, newPlatform);
      });
    });

    group('loadFaceLandmark', () {
      test('throws UnimplementedError', () {
        final platform = _TestTensorflowModelsPlatform();
        expect(platform.loadFaceLandmark, throwsA(isA<UnimplementedError>()));
      });
    });
  });
}
