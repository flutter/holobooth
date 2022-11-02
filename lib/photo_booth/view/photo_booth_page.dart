import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/drawer_selection/bloc/drawer_selection_bloc.dart';
import 'package:io_photobooth/drawer_selection/widgets/drawer_layer.dart';
import 'package:io_photobooth/multiple_capture_viewer/multiple_capture_viewer.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PhotoBoothPage extends StatelessWidget {
  const PhotoBoothPage({super.key});

  static Route<void> route() =>
      AppPageRoute<void>(builder: (_) => const PhotoBoothPage());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PhotoBoothBloc(),
        ),
        BlocProvider(
          create: (_) => DrawerSelectionBloc(),
        )
      ],
      child: const PhotoBoothView(),
    );
  }
}

class PhotoBoothView extends StatefulWidget {
  const PhotoBoothView({super.key});

  @visibleForTesting
  static const cameraErrorViewKey = Key('camera_error_view');

  @visibleForTesting
  static const endDrawerKey =
      Key('photoBoothPage_itemSelectorDrawer_background');

  @override
  State<PhotoBoothView> createState() => _PhotoBoothViewState();
}

class _PhotoBoothViewState extends State<PhotoBoothView> {
  CameraController? _cameraController;

  bool get _isCameraAvailable =>
      (_cameraController?.value.isInitialized) ?? false;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final aspectRatio = orientation == Orientation.portrait
        ? PhotoboothAspectRatio.portrait
        : PhotoboothAspectRatio.landscape;
    return BlocListener<PhotoBoothBloc, PhotoBoothState>(
      listener: (context, state) {
        if (state.isFinished) {
          final images = context.read<PhotoBoothBloc>().state.images;
          Navigator.of(context)
              .pushReplacement(MultipleCaptureViewerPage.route(images));
        }
      },
      child: Scaffold(
        endDrawer: const DrawerLayer(),
        body: CameraBackground(
          aspectRatio: aspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                child: Opacity(
                  opacity: 0,
                  child: CameraView(
                    onCameraReady: (controller) {
                      setState(() => _cameraController = controller);
                    },
                    errorBuilder: (context, error) {
                      if (error is CameraException) {
                        return PhotoboothError(error: error);
                      } else {
                        return const SizedBox.shrink(
                          key: PhotoBoothView.cameraErrorViewKey,
                        );
                      }
                    },
                  ),
                ),
              ),
              if (_isCameraAvailable) ...[
                LayoutBuilder(
                  builder: (context, constraints) =>
                      AvatarDetector(cameraController: _cameraController!),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: MultipleShutterButton(
                    onShutter: _takeSinglePicture,
                  ),
                ),
                if (_isCameraAvailable) const SelectionButtons(),
              ],
            ],
          ),
        ),
      ),
    );
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
}
