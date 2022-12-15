import 'package:flutter/material.dart';
import 'package:io_photobooth/animoji_intro/animoji_intro.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class AnimojiIntroPage extends StatelessWidget {
  const AnimojiIntroPage({super.key});

  static Route<void> route() =>
      AppPageRoute<void>(builder: (_) => const AnimojiIntroPage());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1C2040),
      body: AnimojiIntroView(),
    );
  }
}

class AnimojiIntroView extends StatelessWidget {
  const AnimojiIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPageView(
      background: AnimojiIntroBackground(),
      body: AnimojiIntroBody(),
      footer: FullFooter(),
    );
  }
}
