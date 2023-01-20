import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/audio_player/audio_player.dart';

void main() {
  group('MuteSoundBloc', () {
    test('initial state is unmuted', () {
      expect(MuteSoundBloc().state, MuteSoundState(isMuted: false));
    });

    blocTest<MuteSoundBloc, MuteSoundState>(
      'emits muted state when mute is toggled on',
      build: MuteSoundBloc.new,
      act: (bloc) => bloc.add(MuteSoundToggled()),
      expect: () => [
        MuteSoundState(isMuted: true),
      ],
    );

    blocTest<MuteSoundBloc, MuteSoundState>(
      'emits unmuted state when mute is toggled off',
      build: MuteSoundBloc.new,
      seed: () => MuteSoundState(isMuted: true),
      act: (bloc) => bloc.add(MuteSoundToggled()),
      expect: () => [
        MuteSoundState(isMuted: false),
      ],
    );
  });
}
