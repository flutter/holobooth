import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockVideoPlayerPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements VideoPlayerPlatform {}

class _FakeDataSource extends Fake implements DataSource {}

class _MockConvertBloc extends MockBloc<ConvertEvent, ConvertState>
    implements ConvertBloc {}

void main() {
  group('ShareDialogBody', () {
    late ConvertBloc convertBloc;
    final thumbnail = Uint8List.fromList(transparentImage);

    setUp(() {
      convertBloc = _MockConvertBloc();
      when(() => convertBloc.state)
          .thenReturn(ConvertState(firstFrameProcessed: thumbnail));
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
        await tester.pumpSubject(ShareDialogBody(), convertBloc);
        expect(find.byType(SmallShareDialogBody), findsOneWidget);
      },
    );

    testWidgets(
      'renders LargeShareDialogBody on large screen',
      (WidgetTester tester) async {
        tester.setLargeDisplaySize();
        await tester.pumpSubject(ShareDialogBody(), convertBloc);
        expect(find.byType(LargeShareDialogBody), findsOneWidget);
      },
    );

    testWidgets(
      'can be closed clicking in ShareDialogCloseButton',
      (WidgetTester tester) async {
        await tester.pumpSubject(ShareDialogBody(), convertBloc);
        await tester.tap(find.byType(ShareDialogCloseButton));
        await tester.pumpAndSettle();
        expect(find.byType(ShareDialogBody), findsNothing);
      },
    );

    testWidgets(
      'opens VideoDialog clicking on PlayButton',
      (WidgetTester tester) async {
        await tester.pumpSubject(ShareDialogBody(), convertBloc);
        await tester.tap(find.byType(PlayButton));
        await tester.pumpAndSettle();
        expect(find.byType(VideoDialog), findsOneWidget);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ShareDialogBody subject, ConvertBloc bloc) =>
      pumpApp(
        MultiBlocProvider(
          providers: [BlocProvider.value(value: bloc)],
          child: Material(child: subject),
        ),
      );
}
