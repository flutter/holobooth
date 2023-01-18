import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/audio_player/audio_player.dart';

void main() {
  group('MuteSoundState', () {
    test('uses value equality', () {
      final a = MuteSoundState(isMuted: true);
      final b = MuteSoundState(isMuted: true);
      final c = MuteSoundState(isMuted: false);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });
}
