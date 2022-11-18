import 'dart:ui' as ui show ImageByteFormat, Image;

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gif_compositor/gif_compositor.dart';
import 'package:image/image.dart' as image;

/// {@template exporter}
/// Abstract class for exporting a list of images.
/// {@endtemplate}
abstract class Exporter {
  /// Callback for new frame.
  void onNewFrame(Frame frame);

  /// Exports the recorded frames.
  Future<List<int>?> export();

  /// Exports the recorded frames and composite gif [XFile] with given [name].
  Future<XFile> compositeGif(String name);
}

/// {@template gif_exporter}
/// Exports a list of images as gif.
/// {@endtemplate}
class GifExporter implements Exporter {
  final List<Frame> _frames = [];
  static final List<UintFrame> _rawFrame = [];

  @override
  Future<XFile> compositeGif(String name) async {
    return GifCompositor.composite(
      images: _rawFrame.map((e) => e.uint8list).toList(),
      fileName: name,
    );
  }

  @override
  Future<List<int>?> export() async {
    final bytes = <RawFrame>[];
    for (final frame in _frames) {
      final i = await frame.image.toByteData(format: ui.ImageByteFormat.png);
      if (i != null) {
        bytes.add(RawFrame(16, i));
      } else {
        debugPrint('Skipped frame while enconding');
      }
    }
    final result = compute(_export, bytes);
    _frames.clear();
    return result;
  }

  @override
  void onNewFrame(Frame frame) {
    _frames.add(frame);
    _addRawFrame(frame);
  }

  Future<void> _addRawFrame(Frame frame) async {
    final byteData = await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    _rawFrame.add(
      UintFrame(
        frame.timeStamp.inMicroseconds,
        byteData!.buffer.asUint8List(),
      ),
    );
  }

  static Future<List<int>?> _export(List<RawFrame> frames) async {
    final animation = image.Animation()
      ..backgroundColor = Colors.transparent.value;
    for (final frame in frames) {
      final iAsBytes = frame.image.buffer.asUint8List();
      final decodedImage = image.decodePng(iAsBytes);

      if (decodedImage == null) {
        debugPrint('Skipped frame while enconding');
        continue;
      }
      decodedImage.duration = frame.durationInMillis;
      animation.addFrame(decodedImage);
    }

    return image.encodeGifAnimation(animation);
  }
}

class Frame {
  Frame(this.timeStamp, this.image);

  final Duration timeStamp;
  final ui.Image image;
}

class RawFrame {
  RawFrame(this.durationInMillis, this.image);

  final int durationInMillis;
  final ByteData image;
}

class UintFrame {
  UintFrame(this.durationInMillis, this.uint8list);

  final int durationInMillis;
  final Uint8List uint8list;
}
