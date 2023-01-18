import 'dart:js';

import 'package:meta/meta.dart';

class FirebaseAnalyticsClient {
  /// Exposed [JsObject] for testing purposes.

  @visibleForTesting
  JsObject? testContext;
  JsObject get _testContext => testContext ?? context;

  /// Method which tracks an event for the provided
  /// [category], [action], and [label].
  void trackEvent({
    required String category,
    required String action,
    required String label,
  }) {
    try {
      _testContext.callMethod(
        'ga',
        <dynamic>['send', 'event', category, action, label],
      );
    } catch (_) {}
  }
}
