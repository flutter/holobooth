// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models/tensorflow_models.dart';

class MockTensorFlowFaceLandmarks extends Mock
    implements TensorFlowFaceLandmarks {}

void main() {
  late TensorFlowFaceLandmarks _tensorflowFaceLandmarks;

  setUp(() {
    _tensorflowFaceLandmarks = MockTensorFlowFaceLandmarks();
  });
  group('TensorFlowFaceLandmarks', () {
    test('can be instantiated', () {
      expect(_tensorflowFaceLandmarks, isNotNull);
    });
    test('loads unimplemented faceLandmark', () {
      expect(
        TensorFlowFaceLandmarks.load,
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
