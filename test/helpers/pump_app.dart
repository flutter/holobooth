import 'dart:typed_data';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:download_repository/download_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

class _MockConvertRepository extends Mock implements ConvertRepository {}

class _MockDownloadRepository extends Mock implements DownloadRepository {}

class _MockAvatarDetectorRepository extends Mock
    implements AvatarDetectorRepository {
  _MockAvatarDetectorRepository() {
    registerFallbackValue(
      tf.ImageData(bytes: Uint8List(0), size: tf.Size(0, 0)),
    );

    when(preloadLandmarksModel).thenAnswer((_) => Future.value());
    // ignore: inference_failure_on_function_invocation
    when(() => detectAvatar(any())).thenAnswer((_) async => null);
  }
}

class _FakeAnalyticsEvent extends Fake implements AnalyticsEvent {}

class _MockAnalyticsRepository extends Mock implements AnalyticsRepository {
  _MockAnalyticsRepository() {
    registerFallbackValue(_FakeAnalyticsEvent());

    when(() => trackEvent(any())).thenAnswer((_) {});
  }
}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    AvatarDetectorRepository? avatarDetectorRepository,
    ConvertRepository? convertRepository,
    DownloadRepository? downloadRepository,
    AnalyticsRepository? analyticsRepository,
  }) async {
    return mockNetworkImages(() async {
      return pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(
              value:
                  avatarDetectorRepository ?? _MockAvatarDetectorRepository(),
            ),
            RepositoryProvider.value(
              value: convertRepository ?? _MockConvertRepository(),
            ),
            RepositoryProvider.value(
              value: downloadRepository ?? _MockDownloadRepository(),
            ),
            RepositoryProvider.value(
              value: analyticsRepository ?? _MockAnalyticsRepository(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: widget,
          ),
        ),
      );
    });
  }
}
