import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/drawer_selection/drawer_selection.dart';
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
          create: (_) => DrawerSelectionBloc()
            ..add(
              const DrawerSelectionOptionSelected(
                drawerOption: DrawerOption.backgrounds,
              ),
            ),
        )
      ],
      child: const PhotoBoothView(),
    );
  }
}

class PhotoBoothView extends StatelessWidget {
  const PhotoBoothView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhotoBoothBloc, PhotoBoothState>(
      listener: (context, state) {
        if (state.isFinished) {
          final images = state.images;
          Navigator.of(context)
              .pushReplacement(MultipleCaptureViewerPage.route(images));
        }
      },
      child: const Scaffold(
        endDrawer: DrawerLayer(),
        body: PhotoboothBody(),
      ),
    );
  }
}
