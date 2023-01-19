import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/share/share.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
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

    late VideoPlayerPlatform videoPlayerPlatform;

    setUp(() {
      videoPlayerPlatform = _MockVideoPlayerPlatform();
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
      'renders VideoPlayerView in portrait mode',
      (WidgetTester tester) async {
        tester.setDisplaySize(Size(400, 800));
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
      'can render in fullscreen',
      (WidgetTester tester) async {
        tester.setDisplaySize(Size(800, 800));
        await tester.pumpApp(
          Material(
            child: VideoDialog(
              videoPath: '',
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(VideoPlayerView.fullscreenKey));
        await tester.pumpAndSettle();

        final viewBodyWidget = tester.widget<GradientFrame>(
          find.byKey(VideoPlayerView.viewBodyKey),
        );

        expect(viewBodyWidget.width, equals(800));
        expect(viewBodyWidget.height, equals(800));
      },
    );

    testWidgets(
      'can pause',
      (WidgetTester tester) async {
        await tester.pumpApp(
          Material(
            child: VideoDialog(
              videoPath: '',
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(VideoPlayerView.pauseIconKey));
        await tester.pumpAndSettle();

        expect(find.byKey(VideoPlayerView.playIconKey), findsOneWidget);
      },
    );

    testWidgets(
      'can resume once paused',
      (WidgetTester tester) async {
        await tester.pumpApp(
          Material(
            child: VideoDialog(
              videoPath: '',
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(VideoPlayerView.pauseIconKey));
        await tester.pumpAndSettle();

        expect(find.byKey(VideoPlayerView.playIconKey), findsOneWidget);

        await tester.tap(find.byKey(VideoPlayerView.playIconKey));
        await tester.pumpAndSettle();

        expect(find.byKey(VideoPlayerView.pauseIconKey), findsOneWidget);
      },
    );

    testWidgets(
      'closes the dialog when tapping on the close icon',
      (WidgetTester tester) async {
        await tester.pumpApp(
          Material(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => VideoDialog(
                        videoPath: '',
                      ),
                    );
                  },
                  child: Text('Open dialog'),
                );
              },
            ),
          ),
        );
        await tester.tap(find.text('Open dialog'));
        await tester.pumpAndSettle();

        expect(find.byType(VideoPlayerView), findsOneWidget);

        await tester.tap(find.byKey(VideoPlayerView.closeIconKey));
        await tester.pumpAndSettle();

        expect(find.byType(VideoPlayerView), findsNothing);
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

    testWidgets(
      'progress bar renders correctly when there is no duration',
      (WidgetTester tester) async {
        tester.setDisplaySize(Size(100, 100));
        await tester.pumpApp(
          Material(
            child: VideoProgressBar(
              totalDuration: Duration.zero,
              currentPosition: Duration.zero,
            ),
          ),
        );

        final indicator = tester.widget<Container>(
          find.byKey(VideoProgressBar.indicatorContainerKey),
        );

        expect(indicator.constraints?.maxWidth, equals(0));
      },
    );

    testWidgets(
      'progress bar renders correctly',
      (WidgetTester tester) async {
        tester.setDisplaySize(Size(100, 100));
        await tester.pumpApp(
          Material(
            child: VideoProgressBar(
              totalDuration: Duration(seconds: 10),
              currentPosition: Duration(seconds: 5),
            ),
          ),
        );

        final indicator = tester.widget<Container>(
          find.byKey(VideoProgressBar.indicatorContainerKey),
        );

        expect(indicator.constraints?.maxWidth, equals(50));
      },
    );
  });
}
