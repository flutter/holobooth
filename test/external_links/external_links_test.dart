import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  setUpAll(() {
    registerFallbackValue(LaunchOptions());
  });
  group('external links', () {
    test('launches correct photoboothEmail link', () async {
      final mock = MockUrlLauncher();
      UrlLauncherPlatform.instance = mock;
      when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
      when(
        () => mock.launchUrl(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => true);

      await launchPhotoboothEmail();

      verify(
        () => mock.launchUrl(photoboothEmail, any()),
      ).called(1);
    });
  });
}
