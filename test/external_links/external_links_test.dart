import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  group('External links', () {
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

    group('launchGoogleIOLink', () {
      test('launches correct link', () async {
        await launchGoogleIOLink();
        verify(
          () => mock.launchUrl(googleIOExternalLink, any()),
        ).called(1);
      });
    });

    group('launchFlutterDevLink', () {
      test('launches correct link', () async {
        await launchFlutterDevLink();
        verify(
          () => mock.launchUrl(flutterDevExternalLink, any()),
        ).called(1);
      });
    });

    group('launchFirebaseLink', () {
      test('launches correct link', () async {
        await launchFirebaseLink();
        verify(
          () => mock.launchUrl(firebaseExternalLink, any()),
        ).called(1);
      });
    });

    group('launchPhotoboothEmail', () {
      test('launches correct link', () async {
        await launchPhotoboothEmail();
        verify(
          () => mock.launchUrl(photoboothEmail, any()),
        ).called(1);
      });
    });

    group('launchOpenSourceLink', () {
      test('launches correct link', () async {
        await launchOpenSourceLink();
        verify(
          () => mock.launchUrl(openSourceLink, any()),
        ).called(1);
      });
    });
  });
}
