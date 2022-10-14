import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PhotoboothPage extends StatelessWidget {
  const PhotoboothPage({super.key});

  static Route<void> route() =>
      AppPageRoute<void>(builder: (_) => const PhotoboothPage());

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
  CameraController? _cameraController;

  bool get _isCameraAvailable =>
      (_cameraController?.value.isInitialized) ?? false;

  void _onCameraReady(CameraController cameraController) =>
      setState(() => _cameraController = cameraController);

  Future<void> _stop() async {
    if (!_isCameraAvailable) return;
    return _cameraController!.pausePreview();
  }

  Future<void> _onSnapPressed({required double aspectRatio}) async {
    if (!_isCameraAvailable) return;

    final photoboothBloc = context.read<PhotoboothBloc>();
    final navigator = Navigator.of(context);
    final picture = await _cameraController!.takePicture();
    final previewSize = _cameraController!.value.previewSize!;

    photoboothBloc.add(
      PhotoCaptured(
        aspectRatio: aspectRatio,
        image: PhotoboothCameraImage(
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

    final camera = CameraView(
      onCameraReady: _onCameraReady,
      errorBuilder: (context, error) {
        if (error is CameraException) {
          return PhotoboothError(error: error);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
    return Scaffold(
      body: _PhotoboothBackground(
        aspectRatio: aspectRatio,
        child: _cameraController != null
            ? PhotoboothPreview(
                onSnapPressed: () => _onSnapPressed(aspectRatio: aspectRatio),
                preview: camera,
              )
            : camera,
      ),
    );
  }
}

class _PhotoboothBackground extends StatelessWidget {
  const _PhotoboothBackground({
    required this.aspectRatio,
    required this.child,
  });

  final double aspectRatio;
  final Widget? child;

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
