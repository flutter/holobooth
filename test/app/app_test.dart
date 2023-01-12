import 'package:authentication_repository/authentication_repository.dart';
import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/app/app.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../helpers/helpers.dart';

class _MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class _MockConvertRepository extends Mock implements ConvertRepository {}

class _MockAvatarDetectorRepository extends Mock
    implements AvatarDetectorRepository {
  _MockAvatarDetectorRepository() {
    when(preloadLandmarksModel).thenAnswer((_) => Future.value());
  }
}

void main() {
  group('App', () {
    testWidgets('uses default theme on large devices', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 1000));
      await tester.pumpWidget(
        App(
          authenticationRepository: _MockAuthenticationRepository(),
          avatarDetectorRepository: _MockAvatarDetectorRepository(),
          convertRepository: _MockConvertRepository(),
        ),
      );
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(
        materialApp.theme!.textTheme.headlineLarge!.fontSize,
        equals(PhotoboothTheme.standard.textTheme.headlineLarge!.fontSize),
      );
    });

    testWidgets('uses small theme on small devices', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 500));
      await tester.pumpWidget(
        App(
          authenticationRepository: _MockAuthenticationRepository(),
          avatarDetectorRepository: _MockAvatarDetectorRepository(),
          convertRepository: _MockConvertRepository(),
        ),
      );
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(
        materialApp.theme!.textTheme.headlineLarge!.fontSize,
        equals(PhotoboothTheme.small.textTheme.headlineLarge!.fontSize),
      );
    });

    testWidgets('renders LandingPage', (tester) async {
      await tester.pumpWidget(
        App(
          authenticationRepository: _MockAuthenticationRepository(),
          avatarDetectorRepository: _MockAvatarDetectorRepository(),
          convertRepository: _MockConvertRepository(),
        ),
      );
      expect(find.byType(LandingPage), findsOneWidget);
    });
  });
}
