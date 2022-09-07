import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  group('openLink', () {
    late UrlLauncherPlatform mock;

    setUp(() {
      mock = _MockUrlLauncher();
      UrlLauncherPlatform.instance = mock;
    });

    setUpAll(() {
      registerFallbackValue(_FakeLaunchOptions());
    });

    test('launches the link', () async {
      when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
      when(
        () => mock.launchUrl('url', any()),
      ).thenAnswer((_) async => true);
      await openLink('url');
      verify(
        () => mock.launchUrl('url', any()),
      ).called(1);
    });

    test('executes the onError callback when it cannot launch', () async {
      var wasCalled = false;
      when(() => mock.canLaunch(any())).thenAnswer((_) async => false);

      await openLink(
        'url',
        onError: () {
          wasCalled = true;
        },
      );
      await expectLater(wasCalled, isTrue);
    });
  });
}
