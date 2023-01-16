import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holobooth_ui/holobooth_ui.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/audio_player/audio_player.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/convert/convert.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';

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

class _PhotoBoothViewState extends State<PhotoBoothView> with AudioPlayerMixin {
  @override
  String get audioAssetPath => Assets.audio.experienceAmbient;

  @override
  void initState() {
    super.initState();

    _loadAndPlayAudio();
  }

  Future<void> _loadAndPlayAudio() async {
    await loadAudio();
    await playAudio(loop: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhotoBoothBloc, PhotoBoothState>(
      listener: (context, state) {
        if (state.isFinished) {
          stopAudio();

          Navigator.of(context).pushReplacement(
            ConvertPage.route(state.frames),
          );
        }
      },
      child: const Scaffold(body: PhotoboothBody()),
    );
  }
}
