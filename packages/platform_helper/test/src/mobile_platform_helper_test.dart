@TestOn('!chrome')
library platform_helper;

import 'package:platform_helper/platform_helper.dart';
import 'package:test/test.dart';

void main() {
  group('MobilePlatformHelper', () {
    test('returns true', () {
      final helper = PlatformHelper();
      expect(helper.isMobile, true);
    });
  });
}
