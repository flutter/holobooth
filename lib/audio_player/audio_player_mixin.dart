import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// A mixin that provides an internal [AudioPlayer] instance and methods to play
/// audio.
mixin AudioPlayerMixin<T extends StatefulWidget> on State<T> {
  String get audioAssetPath;

  static AudioPlayer? _audioPlayerOverride;
  static set audioPlayerOverride(AudioPlayer? audioPlayer) =>
      _audioPlayerOverride = audioPlayer;

  late final AudioPlayer _audioPlayer = _audioPlayerOverride ?? AudioPlayer();

  Future<void> loadAudio() async {
    final audioSession = await AudioSession.instance;
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    try {
      await audioSession.configure(const AudioSessionConfiguration.speech());
      await _audioPlayer.setAsset(audioAssetPath);
    } catch (_) {}
  }

  Future<void> playAudio({bool loop = false}) async {
    if (loop) {
      await _audioPlayer.setLoopMode(LoopMode.all);
    }
    await _audioPlayer.play();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
