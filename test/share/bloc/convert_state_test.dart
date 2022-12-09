import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';

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
        final instanceA = ConvertSuccess('not-important');
        final instanceB = ConvertSuccess('not-important');
        expect(instanceA, equals(instanceB));
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
