import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:test/test.dart';

class MockTFModelsPlatform extends Mock implements TensorflowModelsPlatform {}

void main() {
  late TensorflowModelsPlatform _tensorflowModelsPlatform;
  setUp(() {
    _tensorflowModelsPlatform = MockTFModelsPlatform();
  });

  group('TensorflowModelsPlatform', () {
    test('can be instantiated', () {
      expect(_tensorflowModelsPlatform, isNotNull);
    });
    group('loadFaceLandmark', () {
      test('FaceLandmarkDetector', () {
        when(() => _tensorflowModelsPlatform.loadFaceLandmark())
            .thenThrow(UnimplementedError());
      });
    });
  });
}
