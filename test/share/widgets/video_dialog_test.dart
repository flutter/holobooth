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
  group('VideoDialog', () {
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
      when(() => videoPlayerPlatform.videoEventsFor(any())).thenAnswer(
        (_) => Stream.value(VideoEvent(eventType: VideoEventType.initialized)),
      );
    });

    testWidgets(
      'renders VideoPlayerView',
      (WidgetTester tester) async {
        await tester.pumpApp(
          Material(
            child: VideoDialog(
              videoPath: '',
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(VideoPlayerView), findsOneWidget);
      },
    );

    testWidgets(
      'updates scale when initialized',
      (WidgetTester tester) async {
        await tester.pumpApp(
          Material(
            child: VideoDialog(
              videoPath: '',
            ),
          ),
        );
        final animatedScaleFinder = find.byType(AnimatedScale);
        final animatedScale = tester.widget<AnimatedScale>(animatedScaleFinder);
        expect(animatedScale.scale, 0);
        await tester.pumpAndSettle();
        final animatedScaleUpdated =
            tester.widget<AnimatedScale>(animatedScaleFinder);
        expect(animatedScaleUpdated.scale, 1);
      },
    );
  });
}
