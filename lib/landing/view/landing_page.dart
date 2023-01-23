import 'package:flutter/material.dart';
import 'package:holobooth/footer/footer.dart';
import 'package:holobooth/landing/landing.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

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
      children: const [
        Positioned.fill(
          child: LandingBackground(),
        ),
        Positioned.fill(
          child: LandingBody(),
        ),
        Positioned(
          bottom: 100,
          right: 0,
          child: ClassicPhotoboothBanner(),
        ),
      ],
    );
  }
}
