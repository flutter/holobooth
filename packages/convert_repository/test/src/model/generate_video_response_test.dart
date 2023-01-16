import 'dart:typed_data';

import 'package:convert_repository/convert_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GenerateVideoResponse', () {
    test('copyWith', () {
      final response1 = GenerateVideoResponse(
        videoUrl: 'videoUrl',
        gifUrl: 'gifUrl',
        firstFrame: Uint8List(1),
      );
      final response2 = response1.copyWith(videoUrl: 'videoUrl2');
      expect(response1.gifUrl, equals(response2.gifUrl));
      expect(response1.firstFrame, equals(response2.firstFrame));
      expect(response1.videoUrl, isNot(response2.videoUrl));
    });
  });
}
