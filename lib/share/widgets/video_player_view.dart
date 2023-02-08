import 'package:flutter/material.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/widgets/widgets.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    required this.url,
    super.key,
    this.onInitialized,
  });

  final String url;
  final VoidCallback? onInitialized;

  @visibleForTesting
  static const fullscreenKey = Key('player_fullscreen_icon');

  @visibleForTesting
  static const viewBodyKey = Key('player_view_body');

  @visibleForTesting
  static const closeIconKey = Key('player_close_icon');

  @visibleForTesting
  static const playIconKey = Key('player_play_icon');

  @visibleForTesting
  static const pauseIconKey = Key('player_pause_icon');

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late final VideoPlayerController _controller = VideoPlayerController.network(
    widget.url,
  )
    ..initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized,
      // even before the play button has been pressed.
      widget.onInitialized?.call();
      setState(() {
        _totalDuration = _controller.value.duration;
      });
    })
    ..addListener(() {
      setState(() {
        _currentPosition = _controller.value.position;
        _playing = _controller.value.isPlaying;
      });
    })
    ..play();

  Duration _totalDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  bool _fullscreen = false;
  bool _playing = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final modifiers = mediaQuery.orientation == Orientation.portrait
        ? const Offset(.8, .4)
        : const Offset(.75, .8);
    return Align(
      child: GradientFrame(
        key: VideoPlayerView.viewBodyKey,
        borderWidth: _fullscreen ? 0 : 1,
        width: _fullscreen
            ? mediaQuery.size.width
            : mediaQuery.size.width * modifiers.dx,
        height: _fullscreen
            ? mediaQuery.size.height
            : mediaQuery.size.height * modifiers.dy,
        borderRadius: _fullscreen ? 0 : 16,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      right: 10,
                      top: 10,
                      child: _CloseButton(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              VideoProgressBar(
                currentPosition: _currentPosition,
                totalDuration: _totalDuration,
              ),
              const SizedBox(height: 16),
              _Controls(
                playing: _playing,
                onPlayPause: () {
                  if (_playing) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                },
                onFullscreen: () {
                  setState(() {
                    _fullscreen = !_fullscreen;
                  });
                },
                currentSecond: _currentPosition.inSeconds,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return Clickable(
      key: VideoPlayerView.closeIconKey,
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Container(
        width: 54,
        height: 54,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(27.5)),
          color: HoloBoothColors.closeIcon.withOpacity(.56),
        ),
        child: Assets.icons.close.image(),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.onPlayPause,
    required this.onFullscreen,
    required this.currentSecond,
    required this.playing,
  });

  final VoidCallback onPlayPause;
  final VoidCallback onFullscreen;
  final int currentSecond;
  final bool playing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Clickable(
              onPressed: onPlayPause,
              child: SizedBox(
                width: 32,
                height: 32,
                child: Align(
                  child: playing
                      ? Assets.icons.pause.image(
                          key: VideoPlayerView.pauseIconKey,
                          width: 32,
                          height: 32,
                        )
                      : Assets.icons.playerPlay.image(
                          key: VideoPlayerView.playIconKey,
                          width: 20,
                          height: 20,
                        ),
                ),
              ),
            ),
            SizedBox(
              width: 86,
              child: Text(
                '0:0$currentSecond / 0:05',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: HoloBoothColors.white,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const FlutterIconLink(),
            const SizedBox(width: 8),
            const FirebaseIconLink(),
            const SizedBox(width: 8),
            const TensorflowIconLink(),
            const SizedBox(width: 8),
            Clickable(
              key: VideoPlayerView.fullscreenKey,
              onPressed: onFullscreen,
              child: Assets.icons.playerFullscreen.image(
                width: 38,
                height: 38,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class VideoProgressBar extends StatelessWidget {
  const VideoProgressBar({
    required this.currentPosition,
    required this.totalDuration,
    super.key,
  });

  final Duration currentPosition;
  final Duration totalDuration;

  static const indicatorContainerKey = Key('video_progress_indicator');

  @override
  Widget build(BuildContext context) {
    final progress = totalDuration == Duration.zero
        ? 0
        : currentPosition.inMilliseconds / totalDuration.inMilliseconds;
    return Container(
      color: HoloBoothColors.progressBarBackground,
      width: double.infinity,
      height: 8,
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Align(
            alignment: Alignment.topLeft,
            child: Container(
              key: indicatorContainerKey,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                color: HoloBoothColors.progressBarColor,
              ),
              height: 8,
              width: progress * constraints.maxWidth,
            ),
          );
        },
      ),
    );
  }
}
