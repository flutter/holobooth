import 'package:analytics_repository/analytics_repository.dart';
import 'package:firebase_analytics_client/firebase_analytics_client.dart';

/// {@template analytics_repository}
/// Repository which manages tracking analytics.
/// {@endtemplate}
class AnalyticsRepository {
  /// {@macro analytics_repository}
  const AnalyticsRepository(FirebaseAnalyticsClient analytics)
      : _analytics = analytics;

  final FirebaseAnalyticsClient _analytics;

  /// Tracks the provided [AnalyticsEvent].
  void trackEvent(AnalyticsEvent event) {
    _analytics.trackEvent(
      category: event.category,
      action: event.action,
      label: event.label,
    );
  }
}
