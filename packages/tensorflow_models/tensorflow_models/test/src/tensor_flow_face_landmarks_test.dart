// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models/tensorflow_models.dart';

class MockTensorFlowFaceLandmarks extends Mock
    implements TensorFlowFaceLandmarks {}

class MockTFModelsPlatform extends Mock implements TensorflowModelsPlatform {}

void main() {
  late TensorFlowFaceLandmarks _tensorflowFaceLandmarks;
  late TensorflowModelsPlatform _modelsPlatform;

  setUp(() {
    _tensorflowFaceLandmarks = MockTensorFlowFaceLandmarks();
    _modelsPlatform = MockTFModelsPlatform();
  });
  group('TensorFlowFaceLandmarks', () {
    test('can be instantiated', () {
      expect(_tensorflowFaceLandmarks, isNotNull);
    });
    test('loads unimplemented detector', () {
      when(() => _modelsPlatform.loadFaceLandmark())
          .thenThrow(UnimplementedError());
    });
  });
}
