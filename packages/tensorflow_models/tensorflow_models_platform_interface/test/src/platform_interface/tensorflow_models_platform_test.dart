import 'package:flutter_test/flutter_test.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';

class TFModelsPlatformTest extends TensorflowModelsPlatform {}

class TFModelsPlatformBad extends Fake implements TensorflowModelsPlatform {}

void main() {
  group('TensorflowModelsPlatform', () {
    group('instance', () {
      test('sets the instance', () {
        final newPlatform = TFModelsPlatformTest();
        expect(TensorflowModelsPlatform.instance, isNot(equals(newPlatform)));
        TensorflowModelsPlatform.instance = newPlatform;
        expect(TensorflowModelsPlatform.instance, newPlatform);
      });
      test('throws assertion error if token is bad', () {
        final badPlatform = TFModelsPlatformBad();
        expect(
          () => TensorflowModelsPlatform.instance = badPlatform,
          throwsAssertionError,
        );
      });
    });
    group('loadFaceLandmark', () {
      test('throws UnimplementedError', () {
        final platform = TFModelsPlatformTest();
        expect(platform.loadFaceLandmark, throwsA(isA<UnimplementedError>()));
      });
    });
  });
}
