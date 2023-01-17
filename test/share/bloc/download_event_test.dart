import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/share/share.dart';

void main() {
  group('DownloadRequested', () {
    test('can be instantiated', () {
      expect(DownloadRequested(''), isNotNull);
      expect(DownloadRequested.video().extension, equals('mp4'));
      expect(DownloadRequested.gif().extension, equals('gif'));
    });

    test('supports equality', () {
      expect(DownloadRequested(''), equals(DownloadRequested('')));
      expect(DownloadRequested(''), isNot(equals(DownloadRequested('a'))));
    });
  });
}
