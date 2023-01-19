import 'dart:async';

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

  // A future that indicates that the audio player is playing or about to play.
  Future<void> _playing = Future.value();

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
    final completer = Completer<void>();
    _playing = completer.future;
    if (loop && _audioPlayer.loopMode != LoopMode.all) {
      await _audioPlayer.setLoopMode(LoopMode.all);
    }

    try {
      // Restarts the audio track.
      await _audioPlayer.pause();
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
    } catch (_) {
      // If an error occurs, stop the audio.
      await _audioPlayer.stop();
    } finally {
      completer.complete();
    }
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

@visibleForTesting
class TestWidgetWithAudioPlayer extends StatefulWidget {
  const TestWidgetWithAudioPlayer({super.key});

  @override
  State<StatefulWidget> createState() => TestStateWithAudioPlayer();
}

@visibleForTesting
class TestStateWithAudioPlayer extends State<TestWidgetWithAudioPlayer>
    with AudioPlayerMixin {
  @override
  String get audioAssetPath => 'audioAssetPath';

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
