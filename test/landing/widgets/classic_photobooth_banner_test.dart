import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  group('ClassicPhotoboothBanner', () {
    late UrlLauncherPlatform mock;

    setUpAll(() {
      registerFallbackValue(_FakeLaunchOptions());
    });

    setUp(() {
      mock = _MockUrlLauncher();
      UrlLauncherPlatform.instance = mock;
      when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
      when(
        () => mock.launchUrl(any(), any()),
      ).thenAnswer((_) async => true);
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        ClassicPhotoboothBanner(),
      );

      expect(find.text('Classic'), findsOneWidget);
      expect(find.text('Photo Booth'), findsOneWidget);
    });

    testWidgets(
      'opens the classic photo booth url when clicking the banner',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            home: Center(child: ClassicPhotoboothBanner()),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset(0, 0));
        addTearDown(gesture.removePointer);
        await tester.pump();

        await gesture
            .moveTo(tester.getTopLeft(find.byType(AnimatedPositioned)));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Classic'));
        await tester.pumpAndSettle();

        verify(
          () => mock.launchUrl(classicPhotoboothLink, any()),
        ).called(1);
      },
    );
  });
}
