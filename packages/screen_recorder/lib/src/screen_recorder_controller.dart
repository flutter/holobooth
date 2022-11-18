import 'dart:ui' as ui show Image;

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:screen_recorder/src/exporter.dart';

/// {@template screen_recorder_controller}
/// Controller for ScreenRecorder widget.
/// {@endtemplate}
class ScreenRecorderController {
  /// {@macro screen_recorder_controller}
  ScreenRecorderController({
    Exporter? exporter,
    this.pixelRatio = 0.5,
    this.skipFramesBetweenCaptures = 2,
    SchedulerBinding? binding,
  })  : containerKey = GlobalKey(),
        _binding = binding ?? SchedulerBinding.instance,
        _exporter = exporter ?? GifExporter();

  /// The key of the [RepaintBoundary] that is used to record the screen.
  final GlobalKey containerKey;
  final SchedulerBinding _binding;
  final Exporter _exporter;

  /// The pixelRatio describes the scale between the logical pixels and the size
  /// of the output image. Specifying 1.0 will give you a 1:1 mapping between
  /// logical pixels and the output pixels in the image. The default is a pixel
  /// ration of 3 and a value below 1 is not recommended.
  ///
  /// See [RenderRepaintBoundary](https://api.flutter.dev/flutter/rendering/RenderRepaintBoundary/toImage.html)
  /// for the underlying implementation.
  final double pixelRatio;

  /// Describes how many frames are skipped between caputerd frames.
  /// For example if it's `skipFramesBetweenCaptures = 2` screen_recorder
  /// captures a frame, skips the next two frames and then captures the next
  /// frame again.
  final int skipFramesBetweenCaptures;

  int _skipped = 0;

  bool _record = false;

  /// Starts recording the screen.
  void start() {
    // only start a video, if no recording is in progress
    if (_record == true) {
      return;
    }
    _record = true;
    _binding.addPostFrameCallback(_postFrameCallback);
  }

  /// Stops recording the screen.
  void stop() {
    _record = false;
  }

  Future<void> _postFrameCallback(Duration timestamp) async {
    if (_record == false) {
      return;
    }
    if (_skipped > 0) {
      // count down frames which should be skipped
      _skipped = _skipped - 1;
      // add a new PostFrameCallback to know about the next frame
      _binding.addPostFrameCallback(_postFrameCallback);
      // but we do nothing, because we skip this frame
      return;
    }
    if (_skipped == 0) {
      // reset skipped frame counter
      _skipped = _skipped + skipFramesBetweenCaptures;
    }
    try {
      final image = _capture();
      if (image == null) {
        debugPrint('capture returned null');
        return;
      }
      _exporter.onNewFrame(Frame(timestamp, image));
    } catch (error, stackTrace) {
      debugPrint('ScreenRecorderController $error');
      debugPrint('ScreenRecorderController $stackTrace');
    }
    _binding.addPostFrameCallback(_postFrameCallback);
  }

  ui.Image? _capture() {
    final renderObject = containerKey.currentContext!.findRenderObject()
        as RenderRepaintBoundary?;

    return renderObject?.toImageSync(pixelRatio: pixelRatio);
  }

  /// Exports the recorded frames.
  Future<List<int>?> export() => _exporter.export();

  /// Exports the recorded frames and composite gif [XFile] with given [name].
  Future<XFile> compositeGif(String name) => _exporter.compositeGif(name);
}
