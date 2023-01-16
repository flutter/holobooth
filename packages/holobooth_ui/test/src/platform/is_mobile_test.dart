import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

void main() {
  group('isMobile', () {
    test('returns true', () {
      expect(isMobile, equals(true));
    });
  });
}
