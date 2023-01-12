import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// A mixin that provides an internal [AudioPlayer] instance and methods to play
/// audio.
mixin AudioPlayerMixin<T extends StatefulWidget> on State<T> {
  String get audioAssetPath;

  static AudioPlayer? _audioPlayerOverride;
  static set audioPlayerOverride(AudioPlayer? audioPlayer) =>
      _audioPlayerOverride = audioPlayer;

  // A future that indicates that the audio player is playing or about to play.
  Future<void> _playing = Future.value();

  late final AudioPlayer _audioPlayer = _audioPlayerOverride ?? AudioPlayer();

  Future<void> loadAudio() async {
    /*final audioSession = await AudioSession.instance;
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    try {
      await audioSession.configure(const AudioSessionConfiguration.speech());
      await _audioPlayer.setAsset(audioAssetPath);
    } catch (_) {}*/
  }

  Future<void> playAudio({bool loop = false}) async {
    /* final completer = Completer<void>();
    _playing = completer.future;
    if (loop && _audioPlayer.loopMode != LoopMode.all) {
      await _audioPlayer.setLoopMode(LoopMode.all);
    }

    // Restarts the audio track.
    await _audioPlayer.pause();
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.play();
    completer.complete();*/
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    _playing.then((_) => _audioPlayer.dispose());
    super.dispose();
  }
}
