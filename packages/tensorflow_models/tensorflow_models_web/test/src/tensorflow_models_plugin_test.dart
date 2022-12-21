import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart'
    as platform_interface;
import 'package:tensorflow_models_web/tensorflow_models_web.dart';

import '../test_assets/not_a_face.jpg.dart' as not_a_face;
import '../test_assets/real_face.jpg.dart' as real_face;

class AppTester extends StatefulWidget {
  const AppTester({
    super.key,
    required this.imagePath,
    required this.encodedAsset,
    required this.imageSize,
  });

  final String imagePath;
  final String encodedAsset;
  final Size imageSize;

  @override
  State<AppTester> createState() => _AppTesterState();
}

class _AppTesterState extends State<AppTester> {
  int? number;
  bool loading = false;

  String get imagePath => 'test/test_assets/${widget.imagePath}';

  Future<void> loadImage() async {
    final bytes = base64Decode(widget.encodedAsset);

    setState(() {
      loading = true;
    });

    final plugin = TensorflowModelsPlugin();
    final landmark = await plugin.loadFaceLandmark();

    final faces = await landmark.estimateFaces(
      platform_interface.ImageData(
        bytes: bytes,
        size: platform_interface.Size(
          widget.imageSize.width.toInt(),
          widget.imageSize.height.toInt(),
        ),
      ),
    );

    setState(() {
      loading = false;
      number = faces.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: loading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (number != null) Text('Detected faces: $number'),
                    Image.network(
                      imagePath,
                      width: 300,
                    ),
                    ElevatedButton(
                      onPressed: loadImage,
                      child: const Text('Process'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TensorflowModelsPlugin', () {
    testWidgets('recognize a real face', (tester) async {
      runApp(
        AppTester(
          imagePath: 'real_face.jpg',
          encodedAsset: real_face.encodedAsset,
          imageSize: Size(
            real_face.encodedAssetWidth.toDouble(),
            real_face.encodedAssetHeight.toDouble(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Process'));
      await tester.pumpAndSettle();

      expect(find.text('Detected faces: 1'), findsOneWidget);
    });

    testWidgets(
      'does not recognize a face when it is a different thing',
      (tester) async {
        runApp(
          AppTester(
            imagePath: 'not_a_face.jpg',
            encodedAsset: not_a_face.encodedAsset,
            imageSize: Size(
              not_a_face.encodedAssetWidth.toDouble(),
              not_a_face.encodedAssetHeight.toDouble(),
            ),
          ),
        );

        await tester.pumpAndSettle();
        await tester.tap(find.text('Process'));
        await tester.pumpAndSettle();

        expect(find.text('Detected faces: 0'), findsOneWidget);
      },
    );
  });
}
