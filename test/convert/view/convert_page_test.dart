import 'dart:typed_data';

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

class _MockRawFrame extends Mock implements RawFrame {
  @override
  ByteData get image =>
      ByteData.view(Uint8List.fromList(transparentImage).buffer);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ConvertPage', () {
    test('is routable', () {
      expect(ConvertPage.route([]), isA<AppPageRoute<void>>());
    });

    testWidgets('renders ConvertView', (tester) async {
      await tester.pumpApp(
        ConvertPage(
          frames: [_MockRawFrame()],
        ),
        convertRepository: _MockConvertRepository(),
      );

      /// Wait for the player to complete
      await tester.pump(Duration(seconds: 3));
      expect(find.byType(ConvertView), findsOneWidget);
    });
  });

  group('ConvertView', () {
    late ConvertBloc convertBloc;

    setUp(() {
      convertBloc = _MockConvertBloc();
    });

    testWidgets('renders ConvertLoadingBody on loading state', (tester) async {
      when(() => convertBloc.state).thenReturn(
        ConvertState(
          frames: [_MockRawFrame()],
          status: ConvertStatus.loading,
        ),
      );

      await tester.pumpSubject(
        ConvertView(),
        convertBloc,
      );

      expect(find.byType(ConvertLoadingBody), findsOneWidget);
    });

    testWidgets('renders ConvertFinished on other state', (tester) async {
      when(() => convertBloc.state).thenReturn(
        ConvertState(
          frames: [_MockRawFrame()],
          gifPath: 'not-important',
          videoPath: 'not-important',
          status: ConvertStatus.success,
        ),
      );

      await tester.pumpSubject(
        ConvertView(),
        convertBloc,
      );

      /// Wait for the player to complete
      await tester.pump(Duration(seconds: 3));
      expect(find.byType(ConvertFinished), findsOneWidget);
    });

    testWidgets('navigates to SharePage on success', (tester) async {
      final state = ConvertState(
        frames: [_MockRawFrame()],
        isFinished: true,
      );

      whenListen(
        convertBloc,
        Stream.value(state),
        initialState: ConvertState(),
      );

      await tester.pumpSubject(
        ConvertView(),
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
        ConvertView(),
        convertBloc,
      );
      await tester.pump(kThemeAnimationDuration);
      await tester.pump(kThemeAnimationDuration);

      expect(find.byType(SnackBar), findsOneWidget);
    });
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
