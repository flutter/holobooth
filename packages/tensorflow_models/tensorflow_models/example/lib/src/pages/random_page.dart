import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf;

const transparentImage = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
];

class RandomExample extends StatelessWidget {
  const RandomExample({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const RandomExample());

  @override
  Widget build(BuildContext context) => const RandomView();
}

class RandomView extends StatefulWidget {
  const RandomView({Key? key}) : super(key: key);

  @override
  State<RandomView> createState() => _RandomViewState();
}

class _RandomViewState extends State<RandomView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      tf.FaceLandmarksDetector _faceLandmarksDetector =
          await tf.TensorFlowFaceLandmarks.load();
      final image = Uint8List.fromList(transparentImage);
      final imageData = tf.ImageData(
        bytes: image,
        size: tf.Size(100, 100),
      );
      final faces = await _faceLandmarksDetector.estimateFaces(imageData);
      print(faces);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
