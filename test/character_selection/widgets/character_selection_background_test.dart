import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/character_selection/character_selection.dart';

void main() {
  group('Gradients', () {
    test('verifies should not repaint', () async {
      final painter = Gradients(gradient: UnmodifiableListView(List.empty()));
      expect(painter.shouldRepaint(painter), false);
    });
  });
}
