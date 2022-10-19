// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/face_landmarks_detector/widgets/widgets.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';
import 'package:io_photobooth/multiple_capture_viewer/multiple_capture_viewer.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class MultipleCapturePage extends StatelessWidget {
  const MultipleCapturePage({super.key});

  static Route<void> route() =>
      AppPageRoute<void>(builder: (_) => const MultipleCapturePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MultipleCaptureBloc(),
      child: const MultipleCaptureView(),
    );
  }
}

class MultipleCaptureView extends StatefulWidget {
  const MultipleCaptureView({super.key});

  @visibleForTesting
  static const cameraErrorViewKey = Key('camera_error_view');

  @override
  State<MultipleCaptureView> createState() => _MultipleCaptureViewState();
}

class _MultipleCaptureViewState extends State<MultipleCaptureView> {
  CameraController? _cameraController;
  html.VideoElement? _videoElement;

  void _onCameraReady(CameraController cameraController) {
    setState(() => _cameraController = cameraController);
    WidgetsBinding.instance.addPostFrameCallback((_) => _queryVideoElement());
  }

  void _queryVideoElement() {
    final videoElement = html.querySelector('video')! as html.VideoElement;
    setState(() => _videoElement = videoElement);
  }

  bool get _isCameraAvailable =>
      (_cameraController?.value.isInitialized) ?? false;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final aspectRatio = orientation == Orientation.portrait
        ? PhotoboothAspectRatio.portrait
        : PhotoboothAspectRatio.landscape;
    return BlocListener<MultipleCaptureBloc, MultipleCaptureState>(
      listener: (context, state) {
        if (state.isFinished) {
          final images = context.read<MultipleCaptureBloc>().state.images;
          Navigator.of(context)
              .pushReplacement(MultipleCaptureViewerPage.route(images));
        }
      },
      child: Scaffold(
        body: CameraBackground(
          aspectRatio: aspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                child: CameraView(
                  onCameraReady: (controller) {
                    setState(() => _cameraController = controller);
                  },
                  errorBuilder: (context, error) {
                    if (error is CameraException) {
                      return PhotoboothError(error: error);
                    } else {
                      return const SizedBox.shrink(
                        key: MultipleCaptureView.cameraErrorViewKey,
                      );
                    }
                  },
                ),
              ),
              if (_isCameraAvailable && _videoElement != null)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final size = constraints.biggest;
                    _videoElement!
                      ..width = size.width.floor()
                      ..height = size.height.floor();

                    return FacesLandmarksDetectorBuilder(
                      videoElement: _videoElement!,
                      builder: (context, faces) {
                        if (faces.isEmpty) return const SizedBox.shrink();
                        return SizedBox.fromSize(
                          size: size,
                          child: const FlutterLogo(),
                        );
                      },
                    );
                  },
                ),
              if (_isCameraAvailable)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: MultipleShutterButton(
                    onShutter: _takeSinglePicture,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _takeSinglePicture() async {
    final multipleCaptureBloc = context.read<MultipleCaptureBloc>();
    final picture = await _cameraController!.takePicture();
    final previewSize = _cameraController!.value.previewSize!;
    multipleCaptureBloc.add(
      MultipleCaptureOnPhotoTaken(
        image: PhotoboothCameraImage(
          data: picture.path,
          constraint: PhotoConstraint(
            width: previewSize.width,
            height: previewSize.height,
          ),
        ),
      ),
    );
  }
}
