import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:test/test.dart';

class MockTFModelsPlatform extends Mock implements TensorflowModelsPlatform {}

void main() {
  late TensorflowModelsPlatform tensorflowModelsPlatform;
  setUp(() {
    tensorflowModelsPlatform = MockTFModelsPlatform();
  });

  group('TensorflowModelsPlatform', () {
    test('can be instantiated', () {
      expect(tensorflowModelsPlatform, isNotNull);
    });
    group('loadFaceLandmark', () {
      test('FaceLandmarkDetector', () {
        when(() => tensorflowModelsPlatform.loadFaceLandmark())
            .thenThrow(UnimplementedError());
      });
    });
  });
}
