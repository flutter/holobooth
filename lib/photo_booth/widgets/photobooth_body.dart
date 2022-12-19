import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:screen_recorder/screen_recorder.dart';

class PhotoboothBody extends StatefulWidget {
  const PhotoboothBody({super.key});

  @visibleForTesting
  static const cameraErrorViewKey = Key('camera_error_view');

  @override
  State<PhotoboothBody> createState() => _PhotoboothBodyState();
}

class _PhotoboothBodyState extends State<PhotoboothBody> {
  CameraController? _cameraController;
  final ScreenRecorderController _screenRecorderController =
      ScreenRecorderController();

  @override
  void dispose() {
    _screenRecorderController.stop();
    super.dispose();
  }

  bool get _isCameraAvailable =>
      (_cameraController?.value.isInitialized) ?? false;

  void _onCameraReady(CameraController cameraController) {
    setState(() => _cameraController = cameraController);
  }

  Future<void> _takeFrames() async {
    _screenRecorderController.stop();

    final photoBoothBloc = context.read<PhotoBoothBloc>();
    final picture = await _cameraController!.takePicture();
    final previewSize = _cameraController!.value.previewSize!;
    final frames = await _screenRecorderController.exporter.exportFrames();
    photoBoothBloc
      ..add(
        PhotoBoothOnPhotoTaken(
          image: PhotoboothCameraImage(
            data: picture.path,
            constraint: PhotoConstraint(
              width: previewSize.width,
              height: previewSize.height,
            ),
          ),
        ),
      )
      ..add(
        PhotoBoothRecordingFinished(frames ?? []),
      );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, contrains) {
        return ScreenRecorder(
          width: contrains.maxWidth,
          height: contrains.maxHeight,
          controller: _screenRecorderController,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const PhotoboothBackground(),
              Align(
                child: SizedBox.fromSize(
                  size: Size.zero,
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
              const Align(
                child: PhotoboothCharacter(),
              ),
              if (_isCameraAvailable) ...[
                CameraStreamListener(cameraController: _cameraController!),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShutterButton(
                        onCountdownStarted: () {
                          _screenRecorderController.start();
                          context
                              .read<PhotoBoothBloc>()
                              .add(const PhotoBoothRecordingStarted());
                        },
                        onCountdownCompleted: _takeFrames,
                      ),
                      const SimplifiedFooter()
                    ],
                  ),
                ),
              ],
              BlocSelector<PhotoBoothBloc, PhotoBoothState, bool>(
                selector: (state) => state.isRecording,
                builder: (context, isRecording) {
                  if (isRecording) {
                    return const RecordingLayer();
                  }
                  return const SelectionLayer();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
