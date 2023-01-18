import 'package:analytics/src/analytics_io.dart';
import 'package:test/test.dart';

void main() {
  group('trackEvent', () {
    test('returns normally', () {
      expect(
        () => trackEvent(
          category: 'category',
          action: 'action',
          label: 'label',
        ),
        returnsNormally,
      );
    });
  });
}
