import 'package:equatable/equatable.dart';

/// {@template analytics_event}
/// An analytic event which can be tracked.
/// {@endtemplate}
class AnalyticsEvent extends Equatable {
  /// {@macro analytics_event}
  const AnalyticsEvent({
    required this.category,
    required this.action,
    required this.label,
  });

  /// Category name of the event.
  final String category;

  /// Action representing the event.
  final String action;

  /// Identifying label for the event.
  final String label;

  @override
  List<Object?> get props => [category, action, label];
}

/// Mixin for tracking analytics events.
mixin AnalyticsEventMixin on Equatable {
  /// Analytics event which will be tracked.
  AnalyticsEvent get event;

  @override
  List<Object> get props => [event];
}
