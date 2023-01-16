import 'package:flutter/material.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/landing/landing.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: HoloBoothColors.background,
      body: LandingView(),
    );
  }
}

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: LandingBackground(),
        ),
        Positioned.fill(
          child: Column(
            children: const [
              Expanded(child: LandingBody()),
              FullFooter(showIconsForSmall: false),
            ],
          ),
        ),
        const Positioned(
          bottom: 100,
          right: 0,
          child: ClassicPhotoboothBanner(),
        ),
      ],
    );
  }
}
