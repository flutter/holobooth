// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/external_links/external_links.dart';
import 'package:holobooth/footer/footer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  group('FooterLink', () {
    late UrlLauncherPlatform mock;

    setUp(() {
      mock = _MockUrlLauncher();
      UrlLauncherPlatform.instance = mock;
      when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
      when(
        () => mock.launchUrl(any(), any()),
      ).thenAnswer((_) async => true);
    });

    setUpAll(() {
      registerFallbackValue(_FakeLaunchOptions());
    });

    testWidgets('opens link when tapped', (tester) async {
      await tester.pumpApp(
        FooterLink(
          link: 'https://example.com',
          text: 'Link',
        ),
      );

      await tester.tap(find.byType(FooterLink));
      await tester.pumpAndSettle();
      verify(
        () => mock.launchUrl('https://example.com', any()),
      ).called(1);
    });

    group('FlutterForwardFooterLink', () {
      testWidgets('opens proper link on tap', (tester) async {
        await tester.pumpApp(FlutterForwardFooterLink());
        await tester.tap(find.byType(FlutterForwardFooterLink));
        verify(
          () => mock.launchUrl(flutterForwardLink, any()),
        ).called(1);
      });
    });

    group('HowItsMadeFooterLink', () {
      testWidgets('opens proper link on tap', (tester) async {
        await tester.pumpApp(HowItsMadeFooterLink());
        await tester.tap(find.byType(HowItsMadeFooterLink));
        verify(
          () => mock.launchUrl(howItsMadeLink, any()),
        ).called(1);
      });
    });

    group('FooterTermsOfServiceLink', () {
      testWidgets('opens proper link on tap', (tester) async {
        await tester.pumpApp(FooterTermsOfServiceLink());
        await tester.tap(find.byType(FooterTermsOfServiceLink));
        verify(
          () => mock.launchUrl(termsOfServiceLink, any()),
        ).called(1);
      });
    });

    group('FooterPrivacyPolicyLink', () {
      testWidgets('opens proper link on tap', (tester) async {
        await tester.pumpApp(FooterPrivacyPolicyLink());
        await tester.tap(find.byType(FooterPrivacyPolicyLink));
        verify(
          () => mock.launchUrl(privacyPolicyLink, any()),
        ).called(1);
      });
    });
  });
}
