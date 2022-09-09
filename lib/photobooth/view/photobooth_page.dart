import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

// const _videoConstraints = VideoConstraints(
//   facingMode: FacingMode(
//     type: CameraType.user,
//     constrain: Constrain.ideal,
//   ),
//   width: VideoSize(ideal: 1920, maximum: 1920),
//   height: VideoSize(ideal: 1080, maximum: 1080),
// );

class PhotoboothPage extends StatelessWidget {
  const PhotoboothPage({super.key});

  static Route<void> route() {
    return AppPageRoute<void>(builder: (_) => const PhotoboothPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoboothBloc(),
      child: Navigator(
        onGenerateRoute: (_) => AppPageRoute<void>(
          builder: (_) => const PhotoboothView(),
        ),
      ),
    );
  }
}

class PhotoboothView extends StatefulWidget {
  const PhotoboothView({super.key});

  @override
  State<PhotoboothView> createState() => _PhotoboothViewState();
}

class _PhotoboothViewState extends State<PhotoboothView> {
  late Future<void> _cameraInitialized;
  late CameraController _controller;

  bool get _isCameraAvailable => _controller.value.isInitialized;

  CameraException? _error;

  Future<void> _play() async {
    if (!_isCameraAvailable) return;
    return _controller.resumePreview();
  }

  Future<void> _stop() async {
    if (!_isCameraAvailable) return;
    return _controller.pausePreview();
  }

  @override
  void initState() {
    super.initState();
    _cameraInitialized = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    try {
      await _controller.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (error, stackTrace) {
      if (error is CameraException) {
        _error = error;
        return;
      }

      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSnapPressed({required double aspectRatio}) async {
    final photoboothBloc = context.read<PhotoboothBloc>();
    final navigator = Navigator.of(context);
    final picture = await _controller.takePicture();
    final previewSize = _controller.value.previewSize!;

    photoboothBloc.add(
      PhotoCaptured(
        aspectRatio: aspectRatio,
        image: PhotoImage(
          data: picture.path,
          constraint: PhotoConstraint(
            width: previewSize.width,
            height: previewSize.height,
          ),
        ),
      ),
    );
    await _stop();

    final stickersPage = StickersPage.route();

    unawaited(navigator.pushReplacement(stickersPage));
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final aspectRatio = orientation == Orientation.portrait
        ? PhotoboothAspectRatio.portrait
        : PhotoboothAspectRatio.landscape;

    return FutureBuilder<void>(
      future: _cameraInitialized,
      builder: (context, snapshot) {
        late Widget camera;
        if (_error != null) {
          camera = PhotoboothError(error: _error!);
        } else if (snapshot.connectionState == ConnectionState.done) {
          camera = PhotoboothPreview(
            preview: _controller.buildPreview(),
            onSnapPressed: () => _onSnapPressed(aspectRatio: aspectRatio),
          );
        } else {
          camera = const SizedBox();
        }

        return Scaffold(
          body: _PhotoboothBackground(
            aspectRatio: aspectRatio,
            child: camera,
          ),
        );
      },
    );
  }
}

class _PhotoboothBackground extends StatelessWidget {
  const _PhotoboothBackground({
    required this.aspectRatio,
    required this.child,
  });

  final double aspectRatio;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const PhotoboothBackground(),
        Center(
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: ColoredBox(
              color: PhotoboothColors.black,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
