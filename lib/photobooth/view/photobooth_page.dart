import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

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

class _PhotoboothViewState extends State<PhotoboothView>
    with WidgetsBindingObserver {
  late Completer<void> _cameraControllerCompleter;
  CameraController? _controller;

  bool get _isCameraAvailable => (_controller?.value.isInitialized) ?? false;

  Future<void> _stop() async {
    if (!_isCameraAvailable) return;
    return _controller!.pausePreview();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (_isCameraAvailable) return;

    _cameraControllerCompleter = Completer<void>();
    try {
      final cameras = await availableCameras();
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.max,
        enableAudio: false,
      );
      await _controller!.initialize();
      _cameraControllerCompleter.complete();
    } catch (error) {
      _cameraControllerCompleter.completeError(error);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed && _controller == null) {
      _initializeCamera();
      setState(() {});
    }
  }

  Future<void> _onSnapPressed({required double aspectRatio}) async {
    if (!_isCameraAvailable) return;

    final photoboothBloc = context.read<PhotoboothBloc>();
    final navigator = Navigator.of(context);
    final picture = await _controller!.takePicture();
    final previewSize = _controller!.value.previewSize!;

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

    return FutureBuilder<void>(
      future: _cameraControllerCompleter.future,
      builder: (context, snapshot) {
        late final Widget camera;
        if (snapshot.hasError) {
          final error = snapshot.error;
          if (error is CameraException) {
            camera = PhotoboothError(error: error);
          }
        } else if (snapshot.connectionState == ConnectionState.done) {
          camera = PhotoboothPreview(
            preview: _controller!.buildPreview(),
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
