import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/convert/convert.dart';

void main() {
  group('ConvertState', () {
    test('initial support value equality', () {
      final instanceA = ConvertState.initial();
      final instanceB = ConvertState.initial();
      expect(instanceA, equals(instanceB));
    });

    test('copyWith returns new instance', () {
      final instanceA = ConvertState(
        frames: const [],
        videoPath: 'test-video-path',
        gifPath: 'test-gif-path',
      );
      final instanceB = instanceA.copyWith();
      expect(instanceA, equals(instanceB));
      expect(instanceA, isNot(same(instanceB)));
    });
  });
}
