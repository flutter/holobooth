import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class _MockBuildContext extends Mock implements BuildContext {}

class _MockAnimation extends Mock implements Animation<double> {}

void main() {
  group('AppPageRoute', () {
    testWidgets('is a MaterialPageRoute', (tester) async {
      final route = AppPageRoute<void>(builder: (_) => const SizedBox());
      expect(route, isA<MaterialPageRoute<void>>());
    });

    testWidgets('has no transition', (tester) async {
      const child = SizedBox();
      final route = AppPageRoute<void>(builder: (_) => child);
      final transition = route.buildTransitions(
        _MockBuildContext(),
        _MockAnimation(),
        _MockAnimation(),
        child,
      );
      expect(transition, equals(child));
    });
  });
}
