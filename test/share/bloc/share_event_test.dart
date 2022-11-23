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

    group('ShareTapped', () {
      test('support value equality', () {
        final instanceA = ShareTapped(shareUrl: ShareUrl.facebook);
        final instanceB = ShareTapped(shareUrl: ShareUrl.facebook);
        expect(instanceA, equals(instanceB));
      });
    });
  });
}
