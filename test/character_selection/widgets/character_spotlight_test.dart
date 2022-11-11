import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';

void main() {
  group('SpotlightBeam', () {
    test('verifies should not repaint', () async {
      final painter = SpotlightBeam();
      expect(painter.shouldRepaint(painter), false);
    });
  });
  group('SpotlightShadow', () {
    test('verifies should not repaint', () async {
      final painter = SpotlightShadow();
      expect(painter.shouldRepaint(painter), false);
    });
  });
}
