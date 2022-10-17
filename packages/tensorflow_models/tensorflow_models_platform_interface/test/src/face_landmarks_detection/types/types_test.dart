import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import '../../fixtures/estimatefaces.dart';

void main() {
  test('can be deserialized from raw output', () {
    final jsonFaces = json.decode(estimateFacesOutput) as List;
    for (final jsonFace in jsonFaces) {
      expect(
        () => Face.fromJson(jsonFace as Map<String, dynamic>),
        returnsNormally,
      );
    }
  });
}
