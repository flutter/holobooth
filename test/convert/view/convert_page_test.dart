import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:convert_repository/convert_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:screen_recorder/screen_recorder.dart';

import '../../helpers/helpers.dart';

class _MockConvertBloc extends MockBloc<ConvertEvent, ConvertState>
    implements ConvertBloc {}

class _MockConvertRepository extends Mock implements ConvertRepository {}

class _MockRawFrame extends Mock implements RawFrame {
  @override
  ByteData get image =>
      ByteData.view(Uint8List.fromList(transparentImage).buffer);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ConvertBloc convertBloc;
  late ConvertRepository convertRepository;

  setUp(
    () => {
      convertBloc = _MockConvertBloc(),
      convertRepository = _MockConvertRepository(),
      when(() => convertRepository.convertFrames(any())).thenAnswer(
        (_) async => ConvertResponse(
          videoUrl: 'videoUrl',
          gifUrl: 'gifUrl',
        ),
      ),
    },
  );

  group('ConvertPage', () {
    test('is routable', () {
      expect(ConvertPage.route([]), isA<AppPageRoute<void>>());
    });

    testWidgets('renders ConvertView', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 800));

      await tester.pumpApp(
        ConvertPage(
          frames: [_MockRawFrame()],
        ),
        convertRepository: convertRepository,
      );

      /// Wait for the player to complete
      await tester.pump(Duration(seconds: 3));
      expect(find.byType(ConvertView), findsOneWidget);
    });
  });

  group('ConvertView', () {
    testWidgets('renders ConvertLoading on loading state', (tester) async {
      whenListen(
        convertBloc,
        Stream.value(ConvertLoading()),
        initialState: ConvertLoading(),
      );

      await tester.pumpSubject(
        ConvertView(),
        convertBloc,
      );

      expect(find.byKey(Key('ConvertPage_ConvertLoading')), findsOneWidget);
    });
  });

  testWidgets('renders ConvertFinished on other state', (tester) async {
    final state = ConvertSuccess(
      frames: [_MockRawFrame()],
      gifPath: 'not-important',
      videoPath: 'not-important',
    );
    whenListen(
      convertBloc,
      Stream.value(state),
      initialState: state,
    );

    await tester.pumpSubject(
      ConvertView(),
      convertBloc,
    );

    /// Wait for the player to complete
    await tester.pump(Duration(seconds: 3));
    expect(find.byType(ConvertFinished), findsOneWidget);
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(ConvertView subject, ConvertBloc bloc) => pumpApp(
        BlocProvider<ConvertBloc>(
          create: (_) => bloc,
          child: subject,
        ),
      );
}
