import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bloc_test/bloc_test.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:screen_recorder/screen_recorder.dart';

import '../../helpers/helpers.dart';

class _MockConvertBloc extends MockBloc<ConvertEvent, ConvertState>
    implements ConvertBloc {}

class _MockConvertRepository extends Mock implements ConvertRepository {}

class _MockImage extends Mock implements ui.Image {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ConvertPage', () {
    late ui.Image image;
    late List<Frame> frames;
    const totalFrames = 10;
    late ConvertRepository convertRepository;

    setUp(() {
      convertRepository = _MockConvertRepository();
      when(() => convertRepository.convertFrames(any())).thenAnswer(
        (_) async => ConvertResponse(videoUrl: 'videoUrl', gifUrl: 'gifUrl'),
      );
      image = _MockImage();
      when(() => image.toByteData(format: ui.ImageByteFormat.png))
          .thenAnswer((_) async => ByteData(1));
      frames = List.filled(totalFrames, Frame(Duration.zero, image));
    });

    test('is routable', () {
      expect(ConvertPage.route([]), isA<AppPageRoute<void>>());
    });

    testWidgets('renders ConvertView', (tester) async {
      await tester.pumpApp(
        ConvertPage(frames: frames),
        convertRepository: convertRepository,
      );

      expect(find.byType(ConvertView), findsOneWidget);
      await tester.pump(Duration(seconds: 3));
    });
  });

  group('ConvertView', () {
    late ConvertBloc convertBloc;
    late ui.Image image;
    late List<Frame> frames;
    const totalFrames = 10;

    setUp(() {
      convertBloc = _MockConvertBloc();
      image = _MockImage();
      when(() => image.toByteData(format: ui.ImageByteFormat.png))
          .thenAnswer((_) async => ByteData(1));
      frames = List.filled(totalFrames, Frame(Duration.zero, image));
    });

    testWidgets('renders LoadingFramesView on ConvertStatus.loadingFrames',
        (tester) async {
      when(() => convertBloc.state).thenReturn(ConvertState());

      await tester.pumpSubject(
        ConvertView(frames: frames),
        convertBloc,
      );

      expect(find.byType(LoadingFramesView), findsOneWidget);
      await tester.pump(Duration(milliseconds: 300));
    });

    testWidgets('renders CreatingVideoView on ConvertStatus.creatingVideo',
        (tester) async {
      when(() => convertBloc.state)
          .thenReturn(ConvertState(status: ConvertStatus.creatingVideo));

      await tester.pumpSubject(
        ConvertView(frames: frames),
        convertBloc,
      );

      expect(find.byType(CreatingVideoView), findsOneWidget);
      await tester.pump(Duration(milliseconds: 300));
    });

    testWidgets('renders CreatingVideoView on ConvertStatus.framesProcessed',
        (tester) async {
      when(() => convertBloc.state)
          .thenReturn(ConvertState(status: ConvertStatus.framesProcessed));

      await tester.pumpSubject(
        ConvertView(frames: frames),
        convertBloc,
      );

      expect(find.byType(CreatingVideoView), findsOneWidget);
      await tester.pump(Duration(milliseconds: 300));
    });

    testWidgets('renders ConvertFinished ConvertStatus.videoCreated',
        (tester) async {
      when(() => convertBloc.state).thenReturn(
        ConvertState(
          gifPath: 'not-important',
          videoPath: 'not-important',
          status: ConvertStatus.videoCreated,
        ),
      );

      await tester.pumpSubject(
        ConvertView(frames: frames),
        convertBloc,
      );

      expect(find.byType(ConvertFinished), findsOneWidget);
      await tester.pump(Duration(milliseconds: 300));
    });

    testWidgets('renders error view on ConvertStatus.error', (tester) async {
      when(() => convertBloc.state).thenReturn(
        ConvertState(status: ConvertStatus.error),
      );

      await tester.pumpSubject(
        ConvertView(frames: frames),
        convertBloc,
      );

      expect(find.byKey(ConvertBody.errorViewKey), findsOneWidget);
      await tester.pump(Duration(milliseconds: 300));
    });

    testWidgets('navigates to SharePage on success', (tester) async {
      final state = ConvertState(
        isFinished: true,
        processedFrames: [Uint8List.fromList(transparentImage)],
      );

      whenListen(
        convertBloc,
        Stream.value(state),
        initialState: ConvertState(),
      );

      await tester.pumpSubject(
        ConvertView(frames: frames),
        convertBloc,
      );

      /// Wait for the player to complete
      await tester.pump(Duration(seconds: 3));
      await tester.pump();
      expect(find.byType(SharePage), findsOneWidget);
    });

    testWidgets('shows snackbar with error if ', (tester) async {
      whenListen(
        convertBloc,
        Stream.value(ConvertState(status: ConvertStatus.error)),
        initialState: ConvertState(),
      );

      await tester.pumpSubject(
        ConvertView(frames: frames),
        convertBloc,
      );
      await tester.pump(kThemeAnimationDuration);
      await tester.pump(kThemeAnimationDuration);

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ConvertView subject, ConvertBloc convertBloc) =>
      pumpApp(
        BlocProvider<ConvertBloc>.value(
          value: convertBloc,
          child: subject,
        ),
      );
}
