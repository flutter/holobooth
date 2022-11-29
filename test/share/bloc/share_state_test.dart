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

    test('returns updated instance when shareStatus is loading', () {
      expect(
        ShareState().copyWith(shareStatus: ShareStatus.loading),
        ShareState(shareStatus: ShareStatus.loading),
      );
    });

    test('returns updated instance when shareStatus is success', () {
      expect(
        ShareState().copyWith(shareStatus: ShareStatus.success),
        ShareState(shareStatus: ShareStatus.success),
      );
    });

    test('returns updated instance when shareStatus is failure', () {
      expect(
        ShareState().copyWith(shareStatus: ShareStatus.failure),
        ShareState(shareStatus: ShareStatus.failure),
      );
    });

    test('isLoading is only true for loading ShareStatus', () {
      expect(ShareStatus.initial.isLoading, isFalse);

      expect(ShareStatus.loading.isLoading, isTrue);

      expect(ShareStatus.failure.isLoading, isFalse);

      expect(ShareStatus.success.isLoading, isFalse);
    });

    test('isSuccess is only true for success ShareStatus', () {
      expect(ShareStatus.initial.isSuccess, isFalse);

      expect(ShareStatus.loading.isSuccess, isFalse);

      expect(ShareStatus.failure.isSuccess, isFalse);

      expect(ShareStatus.success.isSuccess, isTrue);
    });

    test('isFailure is only true for failure ShareStatus', () {
      expect(ShareStatus.initial.isFailure, isFalse);

      expect(ShareStatus.loading.isFailure, isFalse);

      expect(ShareStatus.failure.isFailure, isTrue);

      expect(ShareStatus.success.isFailure, isFalse);
    });
  });
}
