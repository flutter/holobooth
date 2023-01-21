import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

/// {@template download_repository}
/// Repository responsible for fetching and downloading a file.
/// {@endtemplate}
class DownloadRepository {
  /// {@macro download_repository}
  DownloadRepository({
    Future<http.Response> Function(Uri)? get,
    XFile Function(Uint8List, {String? mimeType, String? name})? parseBytes,
  }) {
    _get = get ?? http.get;
    _parseBytes = parseBytes ?? XFile.fromData;
  }

  late final Future<http.Response> Function(Uri) _get;
  late final XFile Function(Uint8List, {String? mimeType, String? name})
      _parseBytes;

  /// Fetches the given [fileName] and save it locally.
  Future<void> downloadFile({
    required String fileId,
    required String fileName,
    required String mimeType,
  }) async {
    final uri = Uri.parse('/download/$fileId');
    final response = await _get(
      uri,
    );
    final bytes = response.bodyBytes;
    final file = _parseBytes(
      bytes,
      mimeType: mimeType,
      name: fileName,
    );
    await file.saveTo(fileName);
  }
}
