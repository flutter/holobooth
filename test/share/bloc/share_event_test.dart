// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';

void main() {
  group('ShareEvent', () {
    group('ShareViewLoaded', () {
      test('support value equality', () {
        final instanceA = ShareViewLoaded();
        final instanceB = ShareViewLoaded();
        expect(instanceA, equals(instanceB));
      });
    });

    group('ShareOnTwitterTapped', () {
      test('support value equality', () {
        final instanceA = ShareOnTwitterTapped();
        final instanceB = ShareOnTwitterTapped();
        expect(instanceA, equals(instanceB));
      });
    });

    group('ShareOnFacebookTapped', () {
      test('support value equality', () {
        final instanceA = ShareOnFacebookTapped();
        final instanceB = ShareOnFacebookTapped();
        expect(instanceA, equals(instanceB));
      });
    });
  });
}
