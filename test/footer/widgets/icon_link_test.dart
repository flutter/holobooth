// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/external_links/external_links.dart';
import 'package:holobooth/footer/widgets/icon_link.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
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

  group('IconLink', () {
    testWidgets('opens link when tapped', (tester) async {
      const url = 'https://example.com';

      await tester.pumpApp(
        IconLink(
          link: url,
          icon: Icon(Icons.image),
        ),
      );

      await tester.tap(find.byType(IconLink));
      await tester.pumpAndSettle();

      verify(
        () => mock.launchUrl(url, any()),
      ).called(1);
    });
  });

  group('FlutterIconLink', () {
    testWidgets(
      'opens flutterDevExternalLink',
      (WidgetTester tester) async {
        await tester.pumpApp(FlutterIconLink());
        await tester.tap(find.byType(FlutterIconLink));
        verify(
          () => mock.launchUrl(flutterDevExternalLink, any()),
        ).called(1);
      },
    );
  });

  group('FirebaseIconLink', () {
    testWidgets(
      'opens firebaseExternalLink',
      (WidgetTester tester) async {
        await tester.pumpApp(FirebaseIconLink());
        await tester.tap(find.byType(FirebaseIconLink));
        verify(
          () => mock.launchUrl(firebaseExternalLink, any()),
        ).called(1);
      },
    );
  });

  group('TensorflowIconLink', () {
    testWidgets(
      'opens tensorFlowLink',
      (WidgetTester tester) async {
        await tester.pumpApp(TensorflowIconLink());
        await tester.tap(find.byType(TensorflowIconLink));
        verify(
          () => mock.launchUrl(tensorFlowLink, any()),
        ).called(1);
      },
    );
  });

  group('MediapipeIconLink', () {
    testWidgets(
      'opens mediaPipeLink',
      (WidgetTester tester) async {
        await tester.pumpApp(MediapipeIconLink());
        await tester.tap(find.byType(MediapipeIconLink));
        verify(
          () => mock.launchUrl(mediaPipeLink, any()),
        ).called(1);
      },
    );
  });
}
