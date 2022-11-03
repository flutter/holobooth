import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/multiple_capture_viewer/multiple_capture_viewer.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PhotoBoothPage extends StatelessWidget {
  const PhotoBoothPage({super.key});

  static Route<void> route() =>
      AppPageRoute<void>(builder: (_) => const PhotoBoothPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoBoothBloc(),
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
    final screenSize = MediaQuery.of(context).size.width;
    final isBigScreen = screenSize >= PhotoboothBreakpoints.small;
    return BlocListener<PhotoBoothBloc, PhotoBoothState>(
      listener: (context, state) {
        if (state.isFinished) {
          final images = context.read<PhotoBoothBloc>().state.images;
          Navigator.of(context)
              .pushReplacement(MultipleCaptureViewerPage.route(images));
        }
      },
      child: Scaffold(
        endDrawer: ItemSelectorDrawer(
          // TODO(laura177): replace contents of drawer
          key: PhotoBoothView.endDrawerKey,
          title: context.l10n.backgroundSelectorButton,
          items: const [
            PhotoboothColors.red,
            PhotoboothColors.green,
            PhotoboothColors.blue
          ],
          itemBuilder: (context, item) => ColoredBox(color: item),
          selectedItem: PhotoboothColors.red,
          onSelected: (value) => print,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            const PhotoboothBackground(),
            Align(
              child: Opacity(
                opacity: 1,
                child: SizedBox(
                  height: 0,
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
            ),
            if (_isCameraAvailable) ...[
              Align(
                child: LayoutBuilder(
                  builder: (context, constraints) => SizedBox(
                    height: 500,
                    width: 500,
                    child: AvatarDetector(
                      cameraController: _cameraController!,
                    ),
                  ),
                ),
              ),
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
              if (_isCameraAvailable) const SelectionButtons(),
            ],
          ],
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
