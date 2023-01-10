import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RecordScreenExample extends StatefulWidget {
  const RecordScreenExample({super.key});

  @override
  State<RecordScreenExample> createState() => _RecordScreenExampleState();
}

class _RecordScreenExampleState extends State<RecordScreenExample> {
  Uint8List? bytesImages;
  final globalKey = GlobalKey();

  Future<Uint8List?> _getBytesFromImage(ui.Image image) async {
    final bytesImage = await image.toByteData(format: ui.ImageByteFormat.png);
    return bytesImage?.buffer.asUint8List();
  }

  Future<void> generateImage() async {
    final renderObject =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (renderObject != null) {
      final image = renderObject.toImageSync();
      final bytes = await _getBytesFromImage(image);
      setState(() {
        bytesImages = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RepaintBoundary(
            key: globalKey,
            child: Container(
              height: 300,
              width: 300,
              color: Colors.red,
            ),
          ),
          TextButton(
            onPressed: generateImage,
            child: const Text('Capture'),
          ),
          if (bytesImages != null) Image.memory(bytesImages!)
        ],
      ),
    );
  }
}
