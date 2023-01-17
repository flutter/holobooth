import 'package:flutter_test/flutter_test.dart';
import 'package:holobooth/share/share.dart';

void main() {
  group('DownloadEvent', () {
    test('can be instantiated', () {
      expect(DownloadEvent(''), isNotNull);
      expect(DownloadEvent.video().extension, equals('mp4'));
      expect(DownloadEvent.gif().extension, equals('gif'));
    });

    test('supports equality', () {
      expect(DownloadEvent(''), equals(DownloadEvent('')));
      expect(DownloadEvent(''), isNot(equals(DownloadEvent('a'))));
    });
  });
}
