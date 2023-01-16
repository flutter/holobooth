import 'package:flutter/material.dart';
import 'package:io_photobooth/animoji_intro/animoji_intro.dart';
import 'package:io_photobooth/camera/widgets/widgets.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class AnimojiIntroPage extends StatelessWidget {
  const AnimojiIntroPage({super.key});

  static Route<void> route() =>
      AppPageRoute<void>(builder: (_) => const AnimojiIntroPage());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: HoloBoothColors.background,
      body: AnimojiIntroView(),
    );
  }
}

class AnimojiIntroView extends StatelessWidget {
  const AnimojiIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(child: CameraView(onCameraReady: (_) => {})),
        const Positioned.fill(child: AnimojiIntroBackground()),
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                child: AnimojiIntroBody(
                  onNextPressed: () {
                    Navigator.of(context).push(PhotoBoothPage.route());
                  },
                ),
              ),
              const FullFooter(),
            ],
          ),
        ),
      ],
    );
  }
}
