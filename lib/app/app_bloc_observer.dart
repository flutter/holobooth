import 'dart:developer';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc/bloc.dart';

class AppBlocObserver extends BlocObserver {
  AppBlocObserver({
    required AnalyticsRepository analyticsRepository,
  }) : _analyticsRepository = analyticsRepository;

  final AnalyticsRepository _analyticsRepository;

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    log('onTransition(${bloc.runtimeType}, $transition)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    if (event is AnalyticsEventMixin) {
      _analyticsRepository.trackEvent(event.event);
    }
  }
}
