import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class _MockConvertBloc extends MockBloc<ConvertEvent, ConvertState>
    implements ConvertBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AudioPlayer audioPlayer;

  setUp(() {
    audioPlayer = _MockAudioPlayer();
    when(() => audioPlayer.setAsset(any())).thenAnswer((_) async => null);
    when(() => audioPlayer.play()).thenAnswer((_) async {});
    when(() => audioPlayer.stop()).thenAnswer((_) async {});
    when(() => audioPlayer.dispose()).thenAnswer((_) async {});
    when(() => audioPlayer.playerStateStream).thenAnswer(
      (_) => Stream.fromIterable(
        [
          PlayerState(true, ProcessingState.ready),
        ],
      ),
    );

    const MethodChannel('com.ryanheise.audio_session')
        .setMockMethodCallHandler((call) async {
      if (call.method == 'getConfiguration') {
        return {};
      }
    });
  });

  group('ConvertFinished', () {
    testWidgets(
      'set asset correctly',
      (WidgetTester tester) async {
        await tester.pumpApp(
          ConvertFinished(
            dimension: 300,
            audioPlayer: () => audioPlayer,
          ),
        );
        await tester.pumpAndSettle();
        verify(() => audioPlayer.setAsset(any())).called(1);
      },
    );

    testWidgets('renders correctly with loading finish image', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ConvertFinished(
            dimension: 300,
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  'assets/icons/loading_finish.png',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'calls stop on AppLifecycleState.paused',
      (WidgetTester tester) async {
        await tester.pumpApp(
          ConvertFinished(
            dimension: 300,
            audioPlayer: () => audioPlayer,
          ),
        );
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pumpAndSettle();
        verify(() => audioPlayer.stop()).called(1);
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'after the play sound, send the event to the bloc',
      (WidgetTester tester) async {
        final bloc = _MockConvertBloc();

        await tester.pumpApp(
          BlocProvider<ConvertBloc>(
            create: (_) => bloc,
            child: ConvertFinished(
              dimension: 300,
              audioPlayer: () => audioPlayer,
            ),
          ),
        );

        verify(() => bloc.add(const FinishConvert())).called(1);
      },
    );
  });
}
