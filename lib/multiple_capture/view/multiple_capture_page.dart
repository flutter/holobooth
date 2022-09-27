import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/multiple_capture/multiple_capture.dart';
import 'package:io_photobooth/multiple_capture_viewer/multiple_capture_viewer.dart';
import 'package:io_photobooth/photobooth/photobooth.dart'
    show CameraView, PhotoboothError;
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
                  setState(() => _cameraController = controller);
                },
                errorBuilder: (context, error) {
                  if (error is CameraException) {
                    return PhotoboothError(error: error);
                  } else {
                    return const SizedBox.shrink(key: Key('camera_error_view'));
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: MultipleShutterButton(
                onShutter: _takeSinglePicture,
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
