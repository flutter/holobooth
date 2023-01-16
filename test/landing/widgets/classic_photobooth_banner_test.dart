import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/external_links/external_links.dart';
import 'package:holobooth/l10n/l10n.dart';
import 'package:holobooth/landing/landing.dart';
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

      final l10n = tester.element(find.byType(ClassicPhotoboothBanner)).l10n;

      expect(find.text(l10n.classicPhotoboothHeading), findsOneWidget);
      expect(find.text(l10n.classicPhotoboothLabel), findsOneWidget);
    });

    testWidgets(
      'hides and show on hover',
      (tester) async {
        await tester.pumpApp(
          Center(child: ClassicPhotoboothBanner()),
        );

        final l10n = tester.element(find.byType(ClassicPhotoboothBanner)).l10n;

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);
        await tester.pump();

        await gesture.moveTo(
          tester.getTopLeft(find.byType(AnimatedPositioned)),
        );
        await tester.pumpAndSettle();

        expect(
          find.text(l10n.classicPhotoboothHeading).hitTestable(),
          findsOneWidget,
        );

        await gesture.moveTo(Offset.zero);
        await tester.pumpAndSettle();

        expect(
          find.text(l10n.classicPhotoboothHeading).hitTestable(),
          findsNothing,
        );
      },
    );

    testWidgets(
      'opens the classic photo booth url when clicking the banner',
      (tester) async {
        await tester.pumpApp(
          Center(child: ClassicPhotoboothBanner()),
        );

        final l10n = tester.element(find.byType(ClassicPhotoboothBanner)).l10n;

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);
        await tester.pump();

        await gesture.moveTo(
          tester.getTopLeft(find.byType(AnimatedPositioned)),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text(l10n.classicPhotoboothHeading));
        await tester.pumpAndSettle();

        verify(
          () => mock.launchUrl(classicPhotoboothLink, any()),
        ).called(1);
      },
    );
  });
}
