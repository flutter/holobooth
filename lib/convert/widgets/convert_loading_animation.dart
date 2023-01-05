import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

AudioPlayer _getAudioPlayer() => AudioPlayer();

class ConvertLoadingAnimation extends StatefulWidget {
  const ConvertLoadingAnimation({
    super.key,
    required this.dimension,
    ValueGetter<AudioPlayer>? audioPlayer,
  }) : _audioPlayer = audioPlayer ?? _getAudioPlayer;

  final double dimension;

  final ValueGetter<AudioPlayer> _audioPlayer;

  @override
  State<ConvertLoadingAnimation> createState() =>
      _ConvertLoadingAnimationState();
}

class _ConvertLoadingAnimationState extends State<ConvertLoadingAnimation>
    with WidgetsBindingObserver {
  late final AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  Future<void> _init() async {
    audioPlayer = widget._audioPlayer();

    final audioSession = await AudioSession.instance;
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    try {
      await audioSession.configure(const AudioSessionConfiguration.speech());
    } catch (_) {}

    // Try to load audio from a source and catch any errors.
    try {
      await audioPlayer.setAsset(Assets.audio.loading);
      await audioPlayer.setLoopMode(LoopMode.all);
      await audioPlayer.play();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      blur: 24,
      child: Center(
        child: SizedBox.square(
          dimension: widget.dimension,
          child: Stack(
            children: [
              SizedBox.square(
                dimension: widget.dimension,
                child: Assets.icons.loadingCircle.image(
                  key: const Key('LoadingOverlay_LoadingIndicator'),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(widget.dimension * 0.015),
                child: SizedBox.square(
                  dimension: widget.dimension,
                  child: const CircularProgressIndicator(
                    color: Color(0xFFe196d8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      audioPlayer.stop();
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
