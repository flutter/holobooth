import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockMuteSoundBloc extends MockBloc<MuteSoundEvent, MuteSoundState>
    implements MuteSoundBloc {}

void main() {
  group('MuteButton', () {
    late MuteSoundBloc muteSoundBloc;

    setUp(() {
      muteSoundBloc = _MockMuteSoundBloc();
    });

    testWidgets('renders correct icon when muted', (tester) async {
      when(() => muteSoundBloc.state).thenReturn(MuteSoundState(isMuted: true));
      await tester.pumpApp(
        MuteButton(),
        muteSoundBloc: muteSoundBloc,
      );
      expect(
        find.widgetWithIcon(OutlinedButton, Icons.volume_off),
        findsOneWidget,
      );
    });

    testWidgets('renders correct icon when unmuted', (tester) async {
      when(() => muteSoundBloc.state).thenReturn(
        MuteSoundState(
          isMuted: false,
        ),
      );
      await tester.pumpApp(
        MuteButton(),
        muteSoundBloc: muteSoundBloc,
      );
      expect(
        find.widgetWithIcon(OutlinedButton, Icons.volume_up),
        findsOneWidget,
      );
    });

    testWidgets('adds event to bloc when pressed', (tester) async {
      when(() => muteSoundBloc.state).thenReturn(MuteSoundState(isMuted: true));
      await tester.pumpApp(
        MuteButton(),
        muteSoundBloc: muteSoundBloc,
      );
      await tester.tap(find.byType(MuteButton));

      verify(() => muteSoundBloc.add(MuteSoundToggled())).called(1);
    });
  });
}
