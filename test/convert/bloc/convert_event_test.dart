import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/convert/convert.dart';

void main() {
  group('ConvertEvent', () {
    group('ConvertFrames', () {
      test('support value equality', () {
        final instanceA = ConvertFrames(const []);
        final instanceB = ConvertFrames(const []);
        expect(instanceA, equals(instanceB));
      });
    });

    group('FinishConvert', () {
      test('support value equality', () {
        final instanceA = FinishConvert();
        final instanceB = FinishConvert();
        expect(instanceA, equals(instanceB));
      });
    });
  });
}
