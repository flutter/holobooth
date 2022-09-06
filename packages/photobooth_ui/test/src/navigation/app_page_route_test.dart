import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class _MockBuildContext extends Mock implements BuildContext {}

class _MockAnimation extends Mock implements Animation<double> {}

void main() {
  group('AppPageRoute', () {
    testWidgets('is a MaterialPageRoute', (tester) async {
      final route = AppPageRoute(builder: (_) => const SizedBox());
      expect(route, isA<MaterialPageRoute>());
    });

    testWidgets('has no transition', (tester) async {
      const child = SizedBox();
      final route = AppPageRoute(builder: (_) => child);
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
