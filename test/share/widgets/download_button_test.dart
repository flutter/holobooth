import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockConvertBloc extends MockBloc<ConvertEvent, ConvertState>
    implements ConvertBloc {}

class _MockDownloadBloc extends MockBloc<DownloadEvent, DownloadState>
    implements DownloadBloc {}

void main() {
  group('DownloadButton', () {
    late ConvertBloc convertBloc;
    late DownloadBloc downloadBloc;

    setUp(() {
      convertBloc = _MockConvertBloc();
      when(() => convertBloc.state).thenReturn(
        const ConvertState(videoPath: 'https://storage/videoPath.mp4'),
      );

      downloadBloc = _MockDownloadBloc();
      when(() => downloadBloc.state).thenReturn(
        const DownloadState.initial(videoPath: 'https://storage/videoPath.mp4'),
      );
    });

    testWidgets(
        'renders a loading indicator when '
        'ShareStatus.waiting and  ShareType.download', (tester) async {
      when(() => convertBloc.state).thenReturn(
        ConvertState(
          shareStatus: ShareStatus.waiting,
          shareType: ShareType.download,
        ),
      );
      await tester.pumpSubject(
        DownloadButton(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders a loading indicator when DownloadStatus.fetching',
        (tester) async {
      when(() => downloadBloc.state).thenReturn(
        const DownloadState(
          videoPath: 'https://storage/videoPath.mp4',
          status: DownloadStatus.fetching,
        ),
      );

      await tester.pumpSubject(
        DownloadButton(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'opens DownloadOptionDialog if '
        'ShareStatus.ready and ShareType.download', (tester) async {
      whenListen(
        convertBloc,
        Stream.value(
          ConvertState(
            shareStatus: ShareStatus.ready,
            shareType: ShareType.download,
          ),
        ),
        initialState: ConvertState(),
      );
      await tester.pumpSubject(
        DownloadButton(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      await tester.pumpAndSettle();
      expect(find.byType(DownloadOptionDialog), findsOneWidget);
    });

    testWidgets(
        'opens DownloadOptionDialog on tap if ConvertStatus.videoCreated',
        (tester) async {
      when(() => convertBloc.state).thenReturn(
        ConvertState(status: ConvertStatus.videoCreated),
      );
      await tester.pumpSubject(
        DownloadButton(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      await tester.tap(find.byType(DownloadButton));
      await tester.pumpAndSettle();
      expect(find.byType(DownloadOptionDialog), findsOneWidget);
    });

    testWidgets(
        'adds ShareRequested with ShareType.download on tap '
        'if ConvertStatus.creatingVideo', (tester) async {
      when(() => convertBloc.state).thenReturn(
        ConvertState(status: ConvertStatus.creatingVideo),
      );
      await tester.pumpSubject(
        DownloadButton(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      await tester.tap(find.byType(DownloadButton));
      verify(() => convertBloc.add(ShareRequested(ShareType.download)))
          .called(1);
    });

    testWidgets(
        'opens ConvertErrorView on tap if ConvertStatus.errorGeneratingVideo',
        (tester) async {
      when(() => convertBloc.state).thenReturn(
        ConvertState(status: ConvertStatus.errorGeneratingVideo),
      );
      await tester.pumpSubject(
        DownloadButton(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      await tester.tap(find.byType(DownloadButton));
      await tester.pumpAndSettle();
      expect(find.byType(ConvertErrorView), findsOneWidget);
    });

    testWidgets('closes DownloadOptionDialog tapping on DownloadAsAGifButton',
        (tester) async {
      when(() => convertBloc.state).thenReturn(
        ConvertState(status: ConvertStatus.videoCreated),
      );
      await tester.pumpSubject(
        DownloadButton(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      await tester.tap(find.byType(DownloadButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DownloadAsAGifButton));
      await tester.pumpAndSettle();
      expect(find.byType(DownloadOptionDialog), findsNothing);
    });

    testWidgets('closes DownloadOptionDialog tapping on DownloadAsAVideoButton',
        (tester) async {
      when(() => convertBloc.state).thenReturn(
        ConvertState(status: ConvertStatus.videoCreated),
      );
      await tester.pumpSubject(
        DownloadButton(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      await tester.tap(find.byType(DownloadButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DownloadAsAVideoButton));
      await tester.pumpAndSettle();
      expect(find.byType(DownloadOptionDialog), findsNothing);
    });

    testWidgets('downloads the gif when tapping on DownloadAsAGifButton',
        (tester) async {
      when(() => convertBloc.state).thenReturn(
        ConvertState(status: ConvertStatus.videoCreated),
      );
      await tester.pumpSubject(
        DownloadButton(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      await tester.tap(find.byType(DownloadButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DownloadAsAGifButton));
      await tester.pumpAndSettle();

      verify(() => downloadBloc.add(DownloadRequested('gif'))).called(1);
    });

    testWidgets('downloads the mp4 when tapping on DownloadAsAVideoButton',
        (tester) async {
      when(() => convertBloc.state).thenReturn(
        ConvertState(status: ConvertStatus.videoCreated),
      );
      await tester.pumpSubject(
        DownloadButton(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      await tester.tap(find.byType(DownloadButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DownloadAsAVideoButton));
      await tester.pumpAndSettle();

      verify(() => downloadBloc.add(DownloadRequested('mp4'))).called(1);
    });
  });
}

extension BuildSubect on WidgetTester {
  Future<void> pumpSubject(
    Widget subject, {
    required ConvertBloc convertBloc,
    required DownloadBloc downloadBloc,
  }) async {
    await pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: convertBloc),
          BlocProvider.value(value: downloadBloc),
        ],
        child: subject,
      ),
    );
  }
}
