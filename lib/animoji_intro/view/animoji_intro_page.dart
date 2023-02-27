import 'package:flutter/material.dart';
import 'package:holobooth/animoji_intro/animoji_intro.dart';
import 'package:holobooth/footer/footer.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

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
        const Positioned.fill(child: AnimojiIntroBackground()),
        Positioned.fill(
          child: Column(
            children: [
              const Expanded(child: AnimojiIntroBody()),
              FullFooter(),
            ],
          ),
        ),
      ],
    );
  }
}
