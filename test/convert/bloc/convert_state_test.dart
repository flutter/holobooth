import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/convert/convert.dart';

void main() {
  group('ConvertState', () {
    group('ConvertInitial', () {
      test('support value equality', () {
        final instanceA = ConvertInitial();
        final instanceB = ConvertInitial();
        expect(instanceA, equals(instanceB));
      });
    });

    group('ConvertLoading', () {
      test('support value equality', () {
        final instanceA = ConvertLoading();
        final instanceB = ConvertLoading();
        expect(instanceA, equals(instanceB));
      });
    });

    group('ConvertSuccess', () {
      test('support value equality', () {
        expect(
          ConvertSuccess(
            frames: const [],
            videoPath: 'not-important',
            gifPath: 'not-important',
          ),
          equals(
            ConvertSuccess(
              frames: const [],
              videoPath: 'not-important',
              gifPath: 'not-important',
            ),
          ),
        );
        expect(
          ConvertSuccess(
            frames: const [],
            videoPath: 'not-important',
            gifPath: 'not-important',
          ),
          isNot(
            equals(
              ConvertSuccess(
                frames: const [],
                videoPath: 'important',
                gifPath: 'not-important',
              ),
            ),
          ),
        );
        expect(
          ConvertSuccess(
            frames: const [],
            videoPath: 'not-important',
            gifPath: 'not-important',
          ),
          isNot(
            equals(
              ConvertSuccess(
                frames: const [],
                videoPath: 'not-important',
                gifPath: 'important',
              ),
            ),
          ),
        );
      });
    });

    group('ConvertError', () {
      test('support value equality', () {
        final instanceA = ConvertError();
        final instanceB = ConvertError();
        expect(instanceA, equals(instanceB));
      });
    });
  });
}
