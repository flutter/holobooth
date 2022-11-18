import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/props/bloc/props_bloc.dart';

void main() {
  group('PropsState', () {
    test('supports value comparison', () {
      final stateA = PropsState();
      final stateB = stateA.copyWith();
      final stateC = stateA.copyWith(selectedProps: [Prop.helmet]);
      expect(stateA, equals(stateB));
      expect(stateA, isNot(stateC));
    });
  });
}
