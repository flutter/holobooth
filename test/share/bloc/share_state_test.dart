import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/share/share.dart';

void main() {
  group('ShareState', () {
    test('supports value comparison if state is the same', () {
      expect(
        ShareState(shareUrl: ShareUrl.twitter),
        equals(ShareState(shareUrl: ShareUrl.twitter)),
      );
    });

    test('returns same object when no properies are passed', () {
      expect(
        ShareState().copyWith(),
        ShareState(),
      );
    });

    test('returns updated instance when shareUrl is twitter', () {
      expect(
        ShareState().copyWith(shareUrl: ShareUrl.twitter),
        ShareState(shareUrl: ShareUrl.twitter),
      );
    });

    test('returns updated instance when shareUrl is facebook', () {
      expect(
        ShareState().copyWith(shareUrl: ShareUrl.facebook),
        ShareState(shareUrl: ShareUrl.facebook),
      );
    });

    test('returns updated instance when uploadStatus is loading', () {
      expect(
        ShareState().copyWith(uploadStatus: ShareStatus.loading),
        ShareState(uploadStatus: ShareStatus.loading),
      );
    });

    test('returns updated instance when uploadStatus is success', () {
      expect(
        ShareState().copyWith(uploadStatus: ShareStatus.success),
        ShareState(uploadStatus: ShareStatus.success),
      );
    });

    test('returns updated instance when uploadStatus is failure', () {
      expect(
        ShareState().copyWith(uploadStatus: ShareStatus.failure),
        ShareState(uploadStatus: ShareStatus.failure),
      );
    });
  });
}
