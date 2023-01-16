import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bloc_test/bloc_test.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:mocktail/mocktail.dart';
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
      when(() => convertRepository.generateVideo(any())).thenAnswer(
        (_) async => GenerateVideoResponse(
          videoUrl: 'videoUrl',
          gifUrl: 'gifUrl',
          firstFrame: Uint8List(1),
        ),
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
      when(() => convertBloc.state).thenReturn(ConvertState());
      image = _MockImage();
      when(() => image.toByteData(format: ui.ImageByteFormat.png))
          .thenAnswer((_) async => ByteData(1));
      frames = List.filled(totalFrames, Frame(Duration.zero, image));
    });

    testWidgets('renders CreatingVideoView on ConvertStatus.creatingVideo',
        (tester) async {
      when(() => convertBloc.state).thenReturn(ConvertState());

      await tester.pumpSubject(
        ConvertView(frames: frames),
        convertBloc,
      );

      expect(find.byType(CreatingVideoView), findsOneWidget);
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
    });

    testWidgets('shows snackbar with error if ConvertStatus.error',
        (tester) async {
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

    testWidgets('adds GenerateVideoRequested after widget has been initialized',
        (tester) async {
      await tester.pumpSubject(
        ConvertView(frames: frames),
        convertBloc,
      );

      verify(() => convertBloc.add(GenerateVideoRequested(frames))).called(1);
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
