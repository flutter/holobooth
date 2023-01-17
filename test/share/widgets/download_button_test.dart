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

    testWidgets('renders a loading indicator when loading', (tester) async {
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

    testWidgets('opens DownloadOptionDialog on tap', (tester) async {
      await tester.pumpSubject(
        DownloadButton(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      await tester.tap(find.byType(DownloadButton));
      await tester.pumpAndSettle();
      expect(find.byType(DownloadOptionDialog), findsOneWidget);
    });

    testWidgets('closes DownloadOptionDialog tapping on DownloadAsAGifButton',
        (tester) async {
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
      await tester.pumpSubject(
        DownloadButton(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      await tester.tap(find.byType(DownloadButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DownloadAsAGifButton));
      await tester.pumpAndSettle();

      verify(() => downloadBloc.add(DownloadEvent('gif'))).called(1);
    });

    testWidgets('downloads the mp4 when tapping on DownloadAsAVideoButton',
        (tester) async {
      await tester.pumpSubject(
        DownloadButton(),
        convertBloc: convertBloc,
        downloadBloc: downloadBloc,
      );
      await tester.tap(find.byType(DownloadButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DownloadAsAVideoButton));
      await tester.pumpAndSettle();

      verify(() => downloadBloc.add(DownloadEvent('mp4'))).called(1);
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
