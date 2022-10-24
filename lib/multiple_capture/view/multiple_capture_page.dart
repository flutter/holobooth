import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/l10n/l10n.dart';
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
        endDrawer: ItemSelectorDrawer(
          //TODO(laura177): replace contects of drawer with actual Background selection content
          key: const Key('multipleCapturePage_itemSelectorDrawer_background'),
          title: context.l10n.backgroundSelectorButton,
          items: const [Colors.amber, Colors.black, Colors.blue],
          itemBuilder: (context, item) => ColoredBox(color: item),
          selectedItem: Colors.amber,
          onSelected: (value) => print,
        ),
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
              if (_isCameraAvailable)
                LayoutBuilder(
                  builder: (context, constraints) {
                    return AvatarDetector(
                      cameraController: _cameraController!,
                      loadingChild: const SizedBox(),
                      // TODO(OSCAR): add Rive animation
                      child: const SizedBox(),
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
              if (_isCameraAvailable) const SelectionButtons(),
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

class SelectionButtons extends StatelessWidget {
  const SelectionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ItemSelectorButton(
        key: const Key('multipleCapturePage_itemSelector_background'),
        buttonBackground: const ColoredBox(color: Colors.red),
        title: context.l10n.backgroundSelectorButton,
        onTap: () {
          Scaffold.of(context).openEndDrawer();
        },
      ),
    );
  }
}
