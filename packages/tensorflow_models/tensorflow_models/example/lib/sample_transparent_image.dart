// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:tensorflow_models/tensorflow_models.dart';

const List<int> kTransparentImage = <int>[
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

class SampleTransparentImage extends StatefulWidget {
  const SampleTransparentImage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const SampleTransparentImage());
  }

  @override
  State<SampleTransparentImage> createState() => _MyAppState();
}

class _MyAppState extends State<SampleTransparentImage> {
  PoseNet? _net;

  @override
  void initState() {
    super.initState();
    _initializePosenet();
  }

  Future<void> _initializePosenet() async {
    _net?.dispose();
    _net = await load();
    final pose = await _net!.estimateSinglePose('');
    print(pose.score);
    for (final keypoint in pose.keypoints) {
      print(keypoint.part);
      print(keypoint.score);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
