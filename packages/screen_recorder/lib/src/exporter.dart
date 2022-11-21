import 'dart:ui' as ui show ImageByteFormat, Image;

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gif_compositor/gif_compositor.dart';
import 'package:image/image.dart' as image;

/// TODO(arturplaczek): Add tests at final version.

/// {@template exporter}
/// Abstract class for exporting frames.
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
    final gif = GifCompositor.composite(
      images: _rawFrame.map((frame) => frame.uint8list).toList(),
      fileName: name,
    );
    _rawFrame.clear();
    return gif;
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
        frame.timeStamp.inMilliseconds,
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

/// {@template frame}
/// Image frame with duration.
/// {@endtemplate}
class Frame {
  /// {@macro frame}
  Frame(this.timeStamp, this.image);

  /// Frame duration.
  final Duration timeStamp;

  /// Frame image.
  final ui.Image image;
}

/// {@template raw_frame}
/// Frame with image byte data and duration.
/// {@endtemplate}
class RawFrame {
  /// {@macro raw_frame}
  RawFrame(this.durationInMillis, this.image);

  /// Frame duration.
  final int durationInMillis;

  /// Frame image byte data.
  final ByteData image;
}

/// {@template uint_frame}
/// Frame with image byte data and duration.
/// {@endtemplate}
/// Frame with image as [Uint8List] and duration.
class UintFrame {
  /// {@macro uint_frame}
  UintFrame(this.durationInMillis, this.uint8list);

  /// Frame duration.
  final int durationInMillis;

  /// Frame image uint list.
  final Uint8List uint8list;
}
