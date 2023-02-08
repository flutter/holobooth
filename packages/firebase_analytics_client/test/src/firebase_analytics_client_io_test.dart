@TestOn('!chrome')
library firebase_analytics_client;

import 'package:firebase_analytics_client/firebase_analytics_client.dart';
import 'package:test/test.dart';

void main() {
  group('FirebaseAnalyticsClient', () {
    group('trackEvent', () {
      test('returns normally', () {
        expect(
          () => FirebaseAnalyticsClient().trackEvent(
            category: 'category',
            action: 'action',
            label: 'label',
          ),
          returnsNormally,
        );
      });
    });
  });
}
