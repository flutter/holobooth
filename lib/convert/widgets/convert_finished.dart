import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

AudioPlayer _getAudioPlayer() => AudioPlayer();

class ConvertFinished extends StatefulWidget {
  const ConvertFinished({
    super.key,
    required this.dimension,
    ValueGetter<AudioPlayer>? audioPlayer,
  }) : _audioPlayer = audioPlayer ?? _getAudioPlayer;

  final double dimension;
  final ValueGetter<AudioPlayer> _audioPlayer;

  @override
  State<ConvertFinished> createState() => _ConvertFinishedState();
}

class _ConvertFinishedState extends State<ConvertFinished>
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
      await audioPlayer.setAsset(Assets.audio.loadingFinished);
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
                child: Assets.icons.loadingFinish.image(
                  key: const Key('LoadingOverlay_LoadingIndicator'),
                  fit: BoxFit.cover,
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
