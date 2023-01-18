// ignore_for_file: prefer_const_constructors

import 'package:analytics_repository/analytics_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:test/test.dart';

class _TestEvent extends Equatable with AnalyticsEventMixin {
  const _TestEvent({required this.id});

  final String id;

  @override
  AnalyticsEvent get event => AnalyticsEvent(
        category: 'category',
        action: 'action',
        label: 'label$id',
      );
}

void main() {
  group('Event', () {
    test('supports value comparison', () {
      final eventA = AnalyticsEvent(
        category: 'category',
        action: 'action',
        label: 'label',
      );

      final eventB = AnalyticsEvent(
        category: 'category',
        action: 'action',
        label: 'label',
      );

      expect(eventA, equals(eventB));
    });
  });

  group('AnalyticsEventMixin', () {
    test('uses value equality', () {
      expect(_TestEvent(id: '1'), equals(_TestEvent(id: '1')));
    });
  });
}
