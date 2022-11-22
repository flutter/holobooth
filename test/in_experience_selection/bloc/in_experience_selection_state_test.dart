import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';

void main() {
  group('InExperienceSelectionState', () {
    test('supports value comparison', () {
      final stateA = InExperienceSelectionState();
      final stateB = stateA.copyWith();
      final stateC = stateA.copyWith(selectedProps: [Prop.helmet]);
      expect(stateA, equals(stateB));
      expect(stateA, isNot(stateC));
    });
  });
}
