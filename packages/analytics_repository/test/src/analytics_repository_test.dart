import 'package:analytics_repository/analytics_repository.dart';
import 'package:firebase_analytics_client/firebase_analytics_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockFirebaseAnalyticsClient extends Mock
    implements FirebaseAnalyticsClient {}

void main() {
  group('AnalyticsRepository', () {
    late FirebaseAnalyticsClient firebaseAnalyticsClient;
    late AnalyticsRepository analyticsRepository;

    setUp(() {
      firebaseAnalyticsClient = _MockFirebaseAnalyticsClient();
      analyticsRepository = AnalyticsRepository(firebaseAnalyticsClient);
    });

    group('trackEvent', () {
      test('tracks event successfully', () {
        when(
          () => firebaseAnalyticsClient.trackEvent(
            category: any(named: 'category'),
            action: any(named: 'action'),
            label: any(named: 'label'),
          ),
        );
        const event = AnalyticsEvent(
          category: 'category',
          action: 'action',
          label: 'label',
        );
        analyticsRepository.trackEvent(event);

        verify(
          () => firebaseAnalyticsClient.trackEvent(
            category: event.category,
            action: event.action,
            label: event.label,
          ),
        ).called(1);
      });
    });
  });
}
