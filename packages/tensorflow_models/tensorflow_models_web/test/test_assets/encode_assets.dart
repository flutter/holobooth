import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart';

void main() {
  final files = Directory('test/test_assets').listSync();
  for (final file in files) {
    if (file is File && file.path.endsWith('jpg')) {
      final bytes = file.readAsBytesSync();
      final image = decodeImage(bytes);

      if (image == null) {
        throw Exception(
          'Could not decode the image ${file.path}',
        );
      }

      final base64 = base64Encode(image.getBytes());

      File('${file.path}.dart').writeAsStringSync('''
        const encodedAssetWidth = ${image.width};
        const encodedAssetHeight = ${image.height};
        const encodedAsset = '$base64';
        ''');
    }
  }
}
