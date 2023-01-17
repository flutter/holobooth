import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/share/share.dart';

void main() {
  group('DownloadState', () {
    test('can be instantiated', () {
      expect(
        DownloadState(
          videoPath: '',
          status: DownloadStatus.idle,
        ),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        DownloadState(
          videoPath: '',
          status: DownloadStatus.idle,
        ),
        equals(
          DownloadState(
            videoPath: '',
            status: DownloadStatus.idle,
          ),
        ),
      );

      expect(
        DownloadState(
          videoPath: '',
          status: DownloadStatus.idle,
        ),
        isNot(
          equals(
            DownloadState(
              videoPath: 'a',
              status: DownloadStatus.idle,
            ),
          ),
        ),
      );

      expect(
        DownloadState(
          videoPath: '',
          status: DownloadStatus.idle,
        ),
        isNot(
          equals(
            DownloadState(
              videoPath: '',
              status: DownloadStatus.fetching,
            ),
          ),
        ),
      );
    });

    test('copyWith returns a new instance with the updated values', () {
      expect(
        DownloadState(
          videoPath: '',
          status: DownloadStatus.idle,
        ).copyWith(videoPath: 'a'),
        equals(
          DownloadState(
            videoPath: 'a',
            status: DownloadStatus.idle,
          ),
        ),
      );

      expect(
        DownloadState(
          videoPath: '',
          status: DownloadStatus.idle,
        ).copyWith(status: DownloadStatus.fetching),
        equals(
          DownloadState(
            videoPath: '',
            status: DownloadStatus.fetching,
          ),
        ),
      );
    });
  });
}
