import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/drawer_selection/drawer_selection.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';

class PhotoboothBody extends StatefulWidget {
  const PhotoboothBody({super.key});

  @visibleForTesting
  static const cameraErrorViewKey = Key('camera_error_view');

  @override
  State<PhotoboothBody> createState() => _PhotoboothBodyState();
}

class _PhotoboothBodyState extends State<PhotoboothBody> {
  CameraController? _cameraController;

  bool get _isCameraAvailable =>
      (_cameraController?.value.isInitialized) ?? false;

  void _onCameraReady(CameraController cameraController) {
    setState(() => _cameraController = cameraController);
  }

  Future<void> _takeSinglePicture() async {
    final multipleCaptureBloc = context.read<PhotoBoothBloc>();
    final picture = await _cameraController!.takePicture();
    final previewSize = _cameraController!.value.previewSize!;
    multipleCaptureBloc.add(
      PhotoBoothOnPhotoTaken(
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const PhotoboothBackground(),
        Align(
          child: Opacity(
            opacity: 1,
            child: SizedBox(
              height: 0,
              child: CameraView(
                onCameraReady: _onCameraReady,
                errorBuilder: (context, error) {
                  if (error is CameraException) {
                    return PhotoboothError(error: error);
                  } else {
                    return const SizedBox.shrink(
                      key: PhotoboothBody.cameraErrorViewKey,
                    );
                  }
                },
              ),
            ),
          ),
        ),
        const Align(
          child: SizedBox(
            height: 500,
            width: 500,
            child: PhotoboothCharacter(),
          ),
        ),
        if (_isCameraAvailable) ...[
          CameraStreamListener(cameraController: _cameraController!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MultipleShutterButton(
                  onShutter: _takeSinglePicture,
                ),
                const SimplifiedFooter()
              ],
            ),
          ),
        ],
        const SelectionButtons(),
      ],
    );
  }
}
