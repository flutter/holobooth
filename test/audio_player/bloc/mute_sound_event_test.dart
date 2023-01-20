import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/audio_player/audio_player.dart';

void main() {
  group('MuteSoundEvent', () {
    test('uses value equality', () {
      final a = MuteSoundToggled();
      final b = MuteSoundToggled();

      expect(a, equals(b));
    });
  });
}
