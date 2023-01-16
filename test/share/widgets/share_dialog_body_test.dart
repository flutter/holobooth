import 'dart:typed_data';
import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockVideoPlayerPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements VideoPlayerPlatform {}

class _FakeDataSource extends Fake implements DataSource {}

class _MockShareBloc extends MockBloc<ShareEvent, ShareState>
    implements ShareBloc {}

void main() {
  group('ShareDialogBody', () {
    late ShareBloc shareBloc;
    late Uint8List thumbnail;

    setUp(() async {
      shareBloc = _MockShareBloc();
      final image = await createTestImage(height: 10, width: 10);
      final bytesImage = await image.toByteData(format: ImageByteFormat.png);
      thumbnail = bytesImage!.buffer.asUint8List();
      when(() => shareBloc.state).thenReturn(ShareState(thumbnail: thumbnail));
    });

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
        await tester.pumpSubject(ShareDialogBody(), shareBloc);
        expect(find.byType(SmallShareDialogBody), findsOneWidget);
      },
    );

    testWidgets(
      'renders LargeShareDialogBody on large screen',
      (WidgetTester tester) async {
        tester.setLargeDisplaySize();
        await tester.pumpSubject(ShareDialogBody(), shareBloc);
        expect(find.byType(LargeShareDialogBody), findsOneWidget);
      },
    );

    testWidgets(
      'can be closed clicking in ShareDialogCloseButton',
      (WidgetTester tester) async {
        await tester.pumpSubject(ShareDialogBody(), shareBloc);
        await tester.tap(find.byType(ShareDialogCloseButton));
        await tester.pumpAndSettle();
        expect(find.byType(ShareDialogBody), findsNothing);
      },
    );

    testWidgets(
      'opens VideoDialog clicking on PlayButton',
      (WidgetTester tester) async {
        await tester.pumpSubject(ShareDialogBody(), shareBloc);
        await tester.tap(find.byType(PlayButton));
        await tester.pumpAndSettle();
        expect(find.byType(VideoDialog), findsOneWidget);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ShareDialogBody subject, ShareBloc bloc) => pumpApp(
        MultiBlocProvider(
          providers: [BlocProvider.value(value: bloc)],
          child: Material(child: subject),
        ),
      );
}
