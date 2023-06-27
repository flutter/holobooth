import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:just_audio/just_audio.dart' as just_audio;

class AudioPlayerController {
  AudioPlayerController();

  _AudioPlayerState? _state;

  Future<void> playAudio() async => _state?.playAudio();

  Future<void> stopAudio() async => _state?.stopAudio();
}

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({
    required this.audioAssetPath,
    required this.child,
    this.controller,
    this.loop = false,
    this.autoplay = false,
    this.onAudioFinished,
    super.key,
  });

  final String audioAssetPath;
  final Widget child;
  final AudioPlayerController? controller;
  final bool autoplay;
  final bool loop;
  final VoidCallback? onAudioFinished;

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();

  static just_audio.AudioPlayer? _audioPlayerOverride;

  @visibleForTesting
  // ignore: avoid_setters_without_getters
  static set audioPlayerOverride(just_audio.AudioPlayer? audioPlayer) =>
      _audioPlayerOverride = audioPlayer;
}

class _AudioPlayerState extends State<AudioPlayer> {
  // A future that indicates that the audio player is playing or about to play.
  Future<void> _playing = Future.value();

  late final just_audio.AudioPlayer _audioPlayer =
      AudioPlayer._audioPlayerOverride ?? just_audio.AudioPlayer();

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!._state = this;
    }

    _init();
  }

  Future<void> _init() async {
    if (context.read<MuteSoundBloc>().state.isMuted) {
      await _audioPlayer.setVolume(0);
    }
    await loadAudio();
    if (widget.autoplay) {
      await playAudio();
    }
  }

  Future<void> loadAudio() async {
    final audioSession = await AudioSession.instance;
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    try {
      await audioSession.configure(const AudioSessionConfiguration.speech());
      await _audioPlayer.setAsset(widget.audioAssetPath);
    } catch (_) {}

    if (widget.loop && _audioPlayer.loopMode != just_audio.LoopMode.all) {
      await _audioPlayer.setLoopMode(just_audio.LoopMode.all);
    }
  }

  Future<void> playAudio() async {
    final completer = Completer<void>();
    _playing = completer.future;

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
      widget.onAudioFinished?.call();
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<MuteSoundBloc, MuteSoundState>(
      listenWhen: (previous, current) => previous.isMuted != current.isMuted,
      listener: (context, state) {
        if (state.isMuted) {
          _audioPlayer.setVolume(0);
        } else {
          _audioPlayer.setVolume(1);
        }
      },
      child: widget.child,
    );
  }
}
