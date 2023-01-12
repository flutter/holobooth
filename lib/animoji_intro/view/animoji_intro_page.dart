import 'package:flutter/material.dart';
import 'package:io_photobooth/animoji_intro/animoji_intro.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/audio_player/audio_player.dart';
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
      backgroundColor: Color(0xFF1C2040),
      body: AnimojiIntroView(),
    );
  }
}

class AnimojiIntroView extends StatefulWidget {
  const AnimojiIntroView({super.key});

  @override
  State<AnimojiIntroView> createState() => _AnimojiIntroViewState();
}

class _AnimojiIntroViewState extends State<AnimojiIntroView>
    with AudioPlayerMixin {
  @override
  String get audioAssetPath => Assets.audio.landingPageAmbient;

  @override
  void initState() {
    super.initState();

    _loadAndPlayAudio();
  }

  Future<void> _loadAndPlayAudio() async {
    await loadAudio();
    await playAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: AnimojiIntroBackground()),
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                child: AnimojiIntroBody(
                  onNextPressed: () {
                    stopAudio();
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
