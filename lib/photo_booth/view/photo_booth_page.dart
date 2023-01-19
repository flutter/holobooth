import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth/assets/assets.dart';
import 'package:holobooth/audio_player/audio_player.dart';
import 'package:holobooth/avatar_detector/avatar_detector.dart';
import 'package:holobooth/convert/convert.dart';
import 'package:holobooth/in_experience_selection/in_experience_selection.dart';
import 'package:holobooth/photo_booth/photo_booth.dart';
import 'package:holobooth_ui/holobooth_ui.dart';

class PhotoBoothPage extends StatelessWidget {
  const PhotoBoothPage({super.key});

  static Route<void> route() =>
      AppPageRoute<void>(builder: (_) => const PhotoBoothPage());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PhotoBoothBloc()),
        BlocProvider(create: (_) => InExperienceSelectionBloc()),
        BlocProvider(
          create: (_) => AvatarDetectorBloc(
            context.read<AvatarDetectorRepository>(),
          )..add(const AvatarDetectorInitialized()),
        ),
      ],
      child: const PhotoBoothView(),
    );
  }
}

class PhotoBoothView extends StatefulWidget {
  const PhotoBoothView({super.key});

  @override
  State<PhotoBoothView> createState() => _PhotoBoothViewState();
}

class _PhotoBoothViewState extends State<PhotoBoothView> {
  final _audioPlayerController = AudioPlayerController();

  @override
  Widget build(BuildContext context) {
    return AudioPlayer(
      audioAssetPath: Assets.audio.experienceAmbient,
      controller: _audioPlayerController,
      autoplay: true,
      loop: true,
      child: BlocListener<PhotoBoothBloc, PhotoBoothState>(
        listener: (context, state) {
          if (state.isFinished) {
            _audioPlayerController.stopAudio();

            Navigator.of(context).pushReplacement(
              ConvertPage.route(state.frames),
            );
          }
        },
        child: Scaffold(body: PhotoboothBody()),
      ),
    );
  }
}
