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

  void _startRecording() {
    _screenRecorderController.start();
    context.read<PhotoBoothBloc>().add(const PhotoBoothRecordingStarted());
  }

  Future<void> _stopRecording() async {
    _screenRecorderController.stop();
    final photoBoothBloc = context.read<PhotoBoothBloc>();
    final frames = await _screenRecorderController.exporter.exportFrames();
    if (frames != null) {
      photoBoothBloc.add(PhotoBoothRecordingFinished(frames));
    }
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
              const Align(
                alignment: Alignment.bottomCenter,
                child: SimplifiedFooter(),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: PhotoboothCharacter(),
              ),
              Align(child: CameraView(onCameraReady: _onCameraReady)),
              if (_isCameraAvailable) ...[
                CameraStreamListener(cameraController: _cameraController!),
              ],
              BlocBuilder<PhotoBoothBloc, PhotoBoothState>(
                builder: (_, state) {
                  if (state.isRecording) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: RecordingCountdown(
                        onCountdownCompleted: _stopRecording,
                      ),
                    );
                  } else if (state.gettingReady) {
                    return GetReadyLayer(
                      onCountdownCompleted: _startRecording,
                    );
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
