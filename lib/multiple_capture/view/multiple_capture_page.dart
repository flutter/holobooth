import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';
import 'package:io_photobooth/multiple_capture_viewer/multiple_capture_viewer.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class MultipleCapturePage extends StatelessWidget {
  const MultipleCapturePage({super.key});

  static Route<void> route() {
    return AppPageRoute<void>(builder: (_) => const MultipleCapturePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MultipleCaptureBloc(),
      child: const MultipleCaptureView(),
    );
  }
}

class MultipleCaptureView extends StatefulWidget {
  const MultipleCaptureView({super.key});

  @override
  State<MultipleCaptureView> createState() => _MultipleCaptureViewState();
}

class _MultipleCaptureViewState extends State<MultipleCaptureView> {
  late final CameraController _cameraController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MultipleCaptureBloc, MultipleCaptureState>(
      listener: (context, state) {
        if (state.isFinished) {
          final images = context.read<MultipleCaptureBloc>().state.images;
          Navigator.of(context)
              .pushReplacement(MultipleCaptureViewerPage.route(images));
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              child: CameraView(
                onCameraReady: (controller) {
                  setState(() {
                    _cameraController = controller;
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: MultipleShutterButton(
                onPartialShutterCompleted: _takeSinglePicture,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takeSinglePicture() async {
    final multipleCaptureBloc = context.read<MultipleCaptureBloc>();
    final picture = await _cameraController.takePicture();
    final previewSize = _cameraController.value.previewSize!;
    multipleCaptureBloc.add(
      MultipleCapturePhotoTaken(
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
