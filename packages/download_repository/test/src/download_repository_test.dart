// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:download_repository/download_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockResponse extends Mock implements Response {}

class MockXFile extends Mock implements XFile {}

void main() {
  group('DownloadRepository', () {
    test('can be instantiated', () {
      expect(DownloadRepository(), isNotNull);
    });

    test('fetches and save the file', () async {
      final response = MockResponse();
      final file = MockXFile();

      when(() => response.bodyBytes).thenReturn(Uint8List(1));
      when(() => file.saveTo(any())).thenAnswer((_) async {});

      final repo = DownloadRepository(
        get: (_) async => response,
        parseBytes: (_, {String? mimeType, String? name}) => file,
      );

      await repo.downloadFile(
          fileId: 'file', fileName: 'file', mimeType: 'video/mp4');

      verify(() => file.saveTo('file')).called(1);
    });
  });
}
