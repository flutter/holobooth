import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ExampleAudioLoop extends StatefulWidget {
  const ExampleAudioLoop({super.key});

  static Route<void> route() {
    return AppPageRoute<void>(builder: (_) => const ExampleAudioLoop());
  }

  @override
  State<ExampleAudioLoop> createState() => _ExampleAudioLoopState();
}

class _ExampleAudioLoopState extends State<ExampleAudioLoop> {
  late final AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    audioPlayer = AudioPlayer();
    final audioSession = await AudioSession.instance;

    try {
      await audioSession.configure(const AudioSessionConfiguration.speech());
    } catch (_) {}

    // Try to load audio from a source and catch any errors.
    try {
      await audioPlayer.setAsset('assets/audio/camera.mp3');
    } catch (_) {}

    audioPlayer.playerStateStream.listen((event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async {
              await audioPlayer.pause();
              await audioPlayer.seek(Duration.zero);
              unawaited(audioPlayer.play());
            },
            child: const Text('Play audio'),
          ),
        ],
      ),
    ));
  }
}
