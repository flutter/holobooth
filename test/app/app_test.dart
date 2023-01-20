import 'package:analytics_repository/analytics_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:download_repository/download_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/app/app.dart';
import 'package:holobooth/landing/landing.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

class _MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class _MockConvertRepository extends Mock implements ConvertRepository {}

class _MockDownloadRepository extends Mock implements DownloadRepository {}

class _MockAvatarDetectorRepository extends Mock
    implements AvatarDetectorRepository {
  _MockAvatarDetectorRepository() {
    when(preloadLandmarksModel).thenAnswer((_) => Future.value());
  }
}

class _MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

void main() {
  group('App', () {
    late AnalyticsRepository analyticsRepository;

    setUp(() {
      analyticsRepository = _MockAnalyticsRepository();
    });

    testWidgets('uses default theme on large devices', (tester) async {
      tester.setDisplaySize(const Size(HoloboothBreakpoints.large, 1000));
      await tester.pumpWidget(
        App(
          authenticationRepository: _MockAuthenticationRepository(),
          avatarDetectorRepository: _MockAvatarDetectorRepository(),
          convertRepository: _MockConvertRepository(),
          downloadRepository: _MockDownloadRepository(),
          analyticsRepository: analyticsRepository,
        ),
      );
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(
        materialApp.theme!.textTheme.headlineLarge!.fontSize,
        equals(HoloboothTheme.standard.textTheme.headlineLarge!.fontSize),
      );
    });

    testWidgets('uses small theme on small devices', (tester) async {
      tester.setDisplaySize(const Size(HoloboothBreakpoints.small, 500));
      await tester.pumpWidget(
        App(
          authenticationRepository: _MockAuthenticationRepository(),
          avatarDetectorRepository: _MockAvatarDetectorRepository(),
          convertRepository: _MockConvertRepository(),
          downloadRepository: _MockDownloadRepository(),
          analyticsRepository: analyticsRepository,
        ),
      );
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(
        materialApp.theme!.textTheme.headlineLarge!.fontSize,
        equals(HoloboothTheme.small.textTheme.headlineLarge!.fontSize),
      );
    });

    testWidgets('renders LandingPage', (tester) async {
      await tester.pumpWidget(
        App(
          authenticationRepository: _MockAuthenticationRepository(),
          avatarDetectorRepository: _MockAvatarDetectorRepository(),
          convertRepository: _MockConvertRepository(),
          downloadRepository: _MockDownloadRepository(),
          analyticsRepository: analyticsRepository,
        ),
      );
      expect(find.byType(LandingPage), findsOneWidget);
    });
  });
}
