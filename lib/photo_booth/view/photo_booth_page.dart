import 'package:avatar_detector_repository/avatar_detector_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/avatar_detector/avatar_detector.dart';
import 'package:io_photobooth/in_experience_selection/in_experience_selection.dart';
import 'package:io_photobooth/photo_booth/photo_booth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PhotoBoothPage extends StatelessWidget {
  const PhotoBoothPage({super.key, required this.character});

  final Character character;

  static Route<void> route({required Character character}) =>
      AppPageRoute<void>(builder: (_) => PhotoBoothPage(character: character));

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PhotoBoothBloc(),
        ),
        BlocProvider(
          create: (_) =>
              InExperienceSelectionBloc(characterPreSelected: character),
        ),
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

class PhotoBoothView extends StatelessWidget {
  const PhotoBoothView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhotoBoothBloc, PhotoBoothState>(
      listener: (context, state) {
        if (state.isFinished) {
          Navigator.of(context).pushReplacement(
            SharePage.route(
              state.images,
              state.frames,
            ),
          );
        }
      },
      child: const Scaffold(body: PhotoboothBody()),
    );
  }
}
