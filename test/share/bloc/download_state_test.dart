import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/share/share.dart';

void main() {
  group('DownloadState', () {
    test('can be instantiated', () {
      expect(
        DownloadState(),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        DownloadState(),
        equals(
          DownloadState(),
        ),
      );

      expect(
        DownloadState(),
        isNot(
          equals(
            DownloadState(
              status: DownloadStatus.fetching,
            ),
          ),
        ),
      );
    });

    test('copyWith returns a new instance with the updated values', () {
      expect(
        DownloadState().copyWith(),
        equals(
          DownloadState(),
        ),
      );

      expect(
        DownloadState().copyWith(status: DownloadStatus.fetching),
        equals(
          DownloadState(
            status: DownloadStatus.fetching,
          ),
        ),
      );
    });
  });
}
