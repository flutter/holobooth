@TestOn('chrome')
library firebase_analytics_client_web_test;

import 'dart:js';

import 'package:firebase_analytics_client/src/firebase_analytics_client_web.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockJsObject extends Mock implements JsObject {}

void main() {
  group('FirebaseAnalyticsClient', () {
    group('trackEvent', () {
      late JsObject context;
      late FirebaseAnalyticsClient firebaseAnalyticsClient;

      setUp(() {
        context = _MockJsObject();
        firebaseAnalyticsClient = FirebaseAnalyticsClient()
          ..testContext = context;
      });

      test('calls ga on window with correct args', () {
        const category = 'category';
        const action = 'action';
        const label = 'label';

        expect(
          () => firebaseAnalyticsClient.trackEvent(
            category: category,
            action: action,
            label: label,
          ),
          returnsNormally,
        );
        verify<void>(
          () => context.callMethod(
            'ga',
            <dynamic>['send', 'event', category, action, label],
          ),
        ).called(1);
      });
    });
  });
}
