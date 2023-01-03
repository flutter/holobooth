import 'dart:ui' as ui show ImageByteFormat;

import 'package:screen_recorder/screen_recorder.dart';

class CustomExporter extends Exporter {
  final List<RawFrame> frames = [];

  @override
  Future<void> onNewFrame(Frame frame) async {
    final bytesImage =
        await frame.image.toByteData(format: ui.ImageByteFormat.png);
    if (bytesImage != null) {
      frames.add(RawFrame(16, bytesImage));
    }
  }
}
