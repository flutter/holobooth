import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockVideoPlayerPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements VideoPlayerPlatform {}

class _FakeDataSource extends Fake implements DataSource {}

void main() {
  group('ShareDialogBody', () {
    setUpAll(() {
      registerFallbackValue(_FakeDataSource());
    });

    setUp(() {
      final videoPlayerPlatform = _MockVideoPlayerPlatform();
      VideoPlayerPlatform.instance = videoPlayerPlatform;
      when(videoPlayerPlatform.init).thenAnswer((_) async => <void>{});
      when(() => videoPlayerPlatform.create(any()))
          .thenAnswer((invocation) async => 1);
      when(() => videoPlayerPlatform.buildView(any())).thenReturn(SizedBox());
      when(() => videoPlayerPlatform.dispose(any()))
          .thenAnswer((_) async => <void>{});
      when(() => videoPlayerPlatform.videoEventsFor(any()))
          .thenAnswer((_) => Stream.empty());
    });

    testWidgets(
      'renders SmallShareDialogBody on small screen',
      (WidgetTester tester) async {
        tester.setSmallDisplaySize();
        await tester.pumpApp(Material(child: ShareDialogBody()));
        expect(find.byType(SmallShareDialogBody), findsOneWidget);
      },
    );

    testWidgets(
      'renders LargeShareDialogBody on large screen',
      (WidgetTester tester) async {
        tester.setLargeDisplaySize();
        await tester.pumpApp(Material(child: ShareDialogBody()));
        expect(find.byType(LargeShareDialogBody), findsOneWidget);
      },
    );

    testWidgets(
      'can be closed clicking in ShareDialogCloseButton',
      (WidgetTester tester) async {
        await tester.pumpApp(Material(child: ShareDialogBody()));
        await tester.tap(find.byType(ShareDialogCloseButton));
        await tester.pumpAndSettle();
        expect(find.byType(ShareDialogBody), findsNothing);
      },
    );

    testWidgets(
      'opens VideoDialog clicking on PlayButton',
      (WidgetTester tester) async {
        await tester.pumpApp(Material(child: ShareDialogBody()));
        await tester.tap(find.byType(PlayButton));
        await tester.pumpAndSettle();
        expect(find.byType(VideoDialog), findsOneWidget);
      },
    );
  });
}
