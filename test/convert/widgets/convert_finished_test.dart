import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/audio_player/audio_player.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class _MockConvertBloc extends MockBloc<ConvertEvent, ConvertState>
    implements ConvertBloc {}

void main() {
  group('ConvertFinished', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    late AudioPlayer audioPlayer;
    late ConvertBloc convertBloc;

    setUp(() {
      convertBloc = _MockConvertBloc();
      when(() => convertBloc.state).thenReturn(
        ConvertState(
          firstFrameProcessed: Uint8List.fromList(transparentImage),
        ),
      );
      audioPlayer = _MockAudioPlayer();
      when(() => audioPlayer.setAsset(any())).thenAnswer((_) async => null);
      when(() => audioPlayer.play()).thenAnswer((_) async {});
      when(() => audioPlayer.pause()).thenAnswer((_) async {});
      when(() => audioPlayer.seek(any())).thenAnswer((_) async {});
      when(() => audioPlayer.stop()).thenAnswer((_) async {});
      when(() => audioPlayer.dispose()).thenAnswer((_) async {});
      when(() => audioPlayer.playerStateStream).thenAnswer(
        (_) => Stream.fromIterable(
          [
            PlayerState(true, ProcessingState.ready),
          ],
        ),
      );

      AudioPlayerMixin.audioPlayerOverride = audioPlayer;

      const MethodChannel('com.ryanheise.audio_session')
          .setMockMethodCallHandler((call) async {
        if (call.method == 'getConfiguration') {
          return {};
        }
      });
    });

    tearDown(() {
      AudioPlayerMixin.audioPlayerOverride = null;
    });

    testWidgets(
      'set asset correctly',
      (WidgetTester tester) async {
        await tester.pumpSubject(ConvertFinished(dimension: 200), convertBloc);
        await tester.pumpAndSettle();
        verify(() => audioPlayer.setAsset(any())).called(1);
      },
    );

    testWidgets('renders correctly with loading finish image', (tester) async {
      await tester.pumpSubject(ConvertFinished(dimension: 200), convertBloc);

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
      'after the play sound, navigates to SharePage',
      (WidgetTester tester) async {
        await tester.pumpSubject(ConvertFinished(dimension: 200), convertBloc);
        await tester.pumpAndSettle();
        expect(find.byType(SharePage), findsOneWidget);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(
    ConvertFinished subject,
    ConvertBloc convertBloc,
  ) =>
      pumpApp(
        BlocProvider.value(
          value: convertBloc,
          child: subject,
        ),
      );
}
